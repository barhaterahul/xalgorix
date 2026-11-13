---
name: api-recon
description: 'Frontend-driven API/parameter-surface reconnaissance for SPAs and MPAs: harvest static JS bundles for endpoint paths, reverse-engineer the three client-side auth gates (render/interceptor/content), stub-and-record runtime traffic credential-free, drive coverage via UI interaction, restore permission trees, and merge a complete METHOD /path [params] API map. Load this skill BEFORE any web/API testing to build the target surface map; stop at the recon boundary and hand the map to the hunting phase (api-security-testing-playbook).'
tags:
- api-security
- reconnaissance
- spa
- javascript
- rest
- graphql
- jwt
- authorization
domain: cybersecurity
subdomain: application-security
source: adapted from ARTEX skills/api-recon (barhaterahul/ARTEX)
---

# API Recon (frontend API reconnaissance)

Under an **authorized** engagement, discover as completely as possible: **backend APIs** (paths, methods, parameters, response bodies), **frontend routes**, and **UI feature trigger points** (tabs, modals, table actions, etc.).

---

## Environment mapping (this toolset)

The original playbook drives Puppeteer preload scripts. In this environment the same capabilities map to:

| Playbook capability | Here |
|---|---|
| Static harvest of JS bundles | `shell`/`python` in the scan workspace: `curl` the entry HTML, parse webpack/Vite manifests, download chunks, then grep the chunk files |
| Runtime request hooks / stubbing | `browser_action execute_js` — monkey-patch `window.fetch` / `XMLHttpRequest` in the page, then navigate; or `pageagent` flows. Inject hook code early (SPA: right after `launch`, before `goto`) |
| Intercept + record (depth) | A `execute_js` hook that pushes `{url, method, body, headers}` into `window.__RECON_LOG__`; read it back with `execute_js 'JSON.stringify(window.__RECON_LOG__)'` |
| Stub auth/menu responses (coverage) | Hook `fetch`/XHR to return a structurally-correct success body for `login`/`permissions`/`menu` endpoints (L1), rewrite not-logged-in codes to success (L2), empty-success fallback for unmatched `/api` (L3) |
| MPA spidering | `httpclient`/`send_request` + `extract_links`, breadth-first within scope |
| Route-map / permission-tree extraction | `python` tool over the downloaded chunks |

Big files: never read or grep >100KB bundles into context — process them with workspace scripts (`python`), keep only path summaries in the conversation. Cap grep output (`head -20` / `-m 5`).

---

## Boundaries and prohibitions (agents must read — violation means going out of bounds)

This skill **only performs API / parameter-surface reconnaissance**; it is not the vulnerability-hunting or exploitation phase.

### Task boundaries

| Scope | Allowed | Prohibited |
|---|---|---|
| **Target** | Enumerate paths, methods, parameters, routes, UI trigger points | SQLi/XSS/privilege-escalation/brute-force/fuzz vulnerabilities, modified-packet attacks, destructive operations |
| **Auth** | Hook + stub/mock to bypass the **client-side** login gate | Asking the user for or guessing credentials; attempting real login form submissions |
| **Runtime** | Hook endpoints without credentials and use mock responses to get the SPA into its post-login shell | Flows that require a real backend session to continue |

### Credential-free dynamic analysis (Phase 3 default)

1. **Intercept and stub** bootstrap endpoints such as login, permissions, and menus;
2. Return mock bodies for business query endpoints that are **structurally correct, carry a success business code, and may have empty data**;
3. Keep the frontend rendering post-login pages even without a backend or under 401s, thereby triggering more XHR/fetch/WebSocket traffic;
4. **Empty data, blank tables, and placeholder UI are all expected** — do not switch to real login or vulnerability testing over them.

**In one sentence**: use mocks to pry open frontend routes and component mounting and **record outbound requests only**; what the backend returns does not matter — what matters is **which other endpoints the frontend still calls**.

### Hard process prohibitions

| Prohibited | Do this instead |
|---|---|
| grep/curl/Read the main entry `index-*.js` before the static harvest completes | Run the harvest script in the workspace first |
| Hand-writing throwaway extract scripts when the harvest fails | Adjust the harvest script's regex and rerun |
| Repeating the same grep/command after ≥2 failures | Switch strategy: adjust harvest, consult the reference sections below |
| Real usernames/passwords, OTP, OAuth and other authentication | stub/mock (see above) |
| Skipping stubs "to get real data" and running privilege-escalation/injection tests | Record outbound only; that is the recon boundary |
| Irreversible operations such as deletion, exporting sensitive data, or bulk writes | Same for clicks during coverage |
| Claiming all pages and endpoints are captured before runtime + dynamic enumeration complete | See "Definition of done" or note limitations |
| Claiming full parameter coverage before the parameter trigger matrix + diff are done | Phase 3b matrix + Phase 5 diff |
| Inferring required/optional from a single runtime sample | Multi-sample diff or validation rules / error-driven inference |

---

## Two-layer model + run modes

| Layer | Output | Limits |
|---|---|---|
| **Static** (JS bundle) | Full endpoint paths, draft routes, payload-assembly field candidates | No HTTP methods; parameters need Phase 1b; misses runtime-assembled URLs |
| **Runtime** (live session) | Methods + bodies + responses + dynamic URLs + WS/SSE; multi-sample diff fills in parameters | Pages must actually render before requests fire; a single sample cannot settle required/optional |

| Run mode | Engine | Best for |
|---|---|---|
| **depth** | hook-and-navigate (record every request) | API inventory, METHOD/params/response bodies, WS/SSE |
| **coverage** | stub + click-through (tabs/modals/tables) | Deeper feature coverage, module-level endpoints |
| **both** | depth then coverage | Most complete, most time-consuming |

**Parameter methodology** (no universal script): paths via harvest/regex; parameters via **anchor window expansion + UI binding chains + multi-sample diff + error-driven inference** (recipes in the Reference section below).

---

## Definition of done

Recon may only be declared complete when all of the following hold:

- [ ] **Static**: Phase 1 harvest produced `api_static.txt`, `routes.txt`, `js/`
- [ ] **Runtime**: at least one of depth or coverage; coverage/both require **working hooks + the dynamic enumeration loop**
- [ ] **Inside the shell**: visiting business paths does not end up at `/login` (watch out for hash routing)
- [ ] **Parameters**: coverage/both completed the parameter trigger matrix + `param_samples.json`; Phase 5 merged `params_merged.json`
- [ ] **Depth** (if module pages are blank): Phase 4 permission-tree restoration and rerun until **module-level APIs** appear (not just locale/bootstrap)
- [ ] **Delivery**: Phase 5 outputs complete (site map + merged API list saved as notes/assets)

---

## Mandatory SPA ordering

| Step | Required | Prohibited |
|---|---|---|
| After Phase 0 | Next shell command = the static harvest | curl/grep/Read the main entry `index-*.js` (usually >500KB) |
| Gate A | Write/adapt the harvest script → **run immediately** | Hand-extracting APIs first and only then deciding whether to harvest |
| Before Phase 1 completes | Verify outputs with `wc -l`; on 404s fix harvest and retry | Hand-written throwaway extract scripts; repeatedly grepping URLs that were never downloaded |
| From Phase 1b on | grep only the downloaded chunk files | Substituting the main bundle for the harvest |

---

## Execution roadmap

```
Phase 0 classify + workspace (OUTDIR)
  → Gate A → Phase 1 static harvest (run immediately)
  → Phase 1b parameter reverse engineering
  → Phase 2 three auth gates → stub design
  → Gate B → Phase 3 runtime + parameter matrix
  → Phase 4 permission tree (if needed) → rerun Phase 3
  → Phase 5 merge + report (save everything as notes/assets)
```

Check items off in order; **do not move to the next phase before the previous one completes**.

---

## Phase 0 — Classification

Fetch the entry HTML and **create the workspace dir** (`recon/` under the scan dir):

- **SPA**: empty shell + `<div id=app>` + chunk manifests → Phases 1–5
- **MPA**: SSR + `<form>`, no endpoint bundle → spider it breadth-first (`extract_links` + `httpclient`, `--exclude` destructive links like logout/delete), producing `forms.txt`, `links.txt`, `api_inline.txt`. For an SPA, if forms ≈ 0 → switch to Phase 1.

---

## Phase 1 — Static

Write a harvest script into the workspace (entry HTML → script tags → webpack/Vite manifest → download all lazy chunks → `js/`, `api_static.txt`, `routes.txt`, `chunkmap.txt`), run it, then verify:

```bash
wc -l recon/api_static.txt recon/routes.txt
ls recon/js | wc -l
```

- chunk count vs manifest: on 404s fix the harvest and retry; do not hand-curl chunks one by one
- Too few entries in `api_static.txt` → loosen the endpoint regex and rerun (see Reference E)

### Phase 1b — Parameter reverse engineering

Paths come from Phase 1; parameter fields need separate recon.

**Completion bar**: for every important endpoint you can answer — field names, transport location, type inference, required or not, sample values, confidence.

#### 1b.0 — Transport shapes

| Shape | Where parameters live | Look first statically |
|---|---|---|
| REST JSON | body + query | `(params\|data\|body)\s*:\s*\{` next to the path anchor |
| GraphQL | `variables` | gql templates, `$page: Int` |
| Traditional form | urlencoded | `<form>`, `FormData` |
| File upload | multipart | `FormData.append` |
| Path parameters | `/user/:id` | route tables + `useParams` / `$route.params` |
| Encrypted/signed | wrapped in `sign`/`data` | Hook the crypto function's inputs (Reference J5) |

Output: annotate each endpoint with `transport: query|json|form|graphql|encrypted`.

#### 1b.1 — Anchor window expansion

Anchor on a known path and widen the window to find the payload-assembly object:

```bash
grep -n '"/api/user/list"' recon/js/*.js | head -20
grep -rhoaE '.{0,120}("/api[^"]+").{0,200}' recon/js/*.js | head -20
grep -rhoaE '(params|data|body|payload)\s*:\s*\{' recon/js/*.js | head -20
```

| Wrapper layer | Parameter clues |
|---|---|
| axios instance | `data` / `params` |
| Unified request | Global fields injected by interceptors |
| OpenAPI client | Generated method signatures |
| React Query / SWR | The hook's second argument |
| Vue composable | Composable inputs |

Type leftovers: `yup`/`zod`/rules, `Form.Item name=`, embedded Swagger.

→ `param_candidates.json`: `{ path, fields[], source: "static-callsite", confidence }`

#### 1b.2 — Binding layer

```
Form field → onFinish/handleSubmit → transform → API payload
```

| Binding source | Technique |
|---|---|
| Form submit | Follow submit → transform → API |
| Table search | `getFieldsValue()` → `params` |
| Route | `:id` / `?tab=` |
| Interceptor | Global `tenantId`, pagination, sign |
| Enum select | `options` → API enum values |

Use the browser call stack to walk up from `fetch`/`XHR.send` to the payload-assembly function.

#### 1b.3 — Three payload-assembly questions (≠ Phase 2's three auth gates)

| Question | What to answer |
|---|---|
| **Assembly** | Where the payload is built, transform traces |
| **Validation** | required, pattern, enum |
| **Transport** | path / query / body / multipart / headers |

The interceptor gate (Phase 2) is also where globally injected fields get read (Authorization, `X-Tenant-Id`, sign).

#### 1b.4 — Connecting to Phase 3

Candidate fields come from the static/binding layers; **required/optional/conditional dependencies** need the Phase 3 parameter matrix + diff + Phase 5 error-driven inference.

---

## Phase 2 — The three auth gates

grep in the downloaded chunks (with `head`) and record the findings (recipes in Reference A):

| Gate | Question | Keywords |
|---|---|---|
| **Render gate** | How does the app decide the user is logged in? | `isLogin`, `getToken`, Cookie/localStorage |
| **Interceptor gate** | What triggers a redirect to `/login`? | `response_code`, `errno`, axios interceptor |
| **Content gate** | Where do menus/permissions come from? | `menu`, `permission`, `role`, `acl`, `routes` |

Never treat a localStorage key name as a credential — confirm it from chunks/the request chain.

**Exit**: land the conclusions in the stub design (forged cookie/localStorage values, neutralize field list, menu stub bodies) ready for Phase 3 injection.

---

## Phase 3 — Runtime

Follow the credential-free mock strategy from the Boundaries section.

### Hook and stub tiers (shared by depth + coverage)

| Tier | Scope | Purpose |
|---|---|---|
| L1 precise | auth/permissions/bootstrap stubs | Pass first-screen auth |
| L2 negative fix-up | All JSON responses | Not-logged-in code → success |
| L3 fallback | `/api` etc. not matched by L1 | Empty success body to pry open the UI |

- **depth**: fake auth via forged cookie/localStorage (set with `execute_js`), hook fetch/XHR to record; iterate route paths; produce `runtime_api.json`
- **coverage**: install the hook stub **before first navigation** so it survives document reloads; re-inject after any full page load

Verify: the hook global exists (`window.__RECON_LOG__`); business paths do not fall back to `/login`.

### 3b — Coverage dynamic enumeration (mandatory)

1. Main nav/sidebar — click each item, wait 1–3s for the network
2. Tabs — `role=tab`, `.ant-tabs-tab`
3. Tables — first-row view/edit/detail
4. Toolbars — export, filter, create (**avoid irreversible deletes**)
5. On entering each module — merge APIs/routes
6. SPA — controlled `pushState` for paths not covered by `routes.txt` (forbidden for MPA)

**Parameter trigger matrix** (mandatory): record once per operation type per module and **diff the multiple samples**:

| Operation | Parameters usually gained |
|---|---|
| List first screen | Pagination + default filters |
| Click search | keyword, filter |
| Advanced filter | More optionals |
| Create/edit | Full entity |
| Bulk/export/sort | `ids[]`, `exportType`, `sortField` |

**Under stubs the outbound body/headers are still real** — the request is the source of truth. Recording → `scan_raw.json`, `param_samples.json`, `api_detail.json`.

- **Vue**: neutralize the router guards in the hook; capture registered routes
- **React**: `routes.txt` + sidebar clicks + `pushState`
- **both**: depth first, then coverage

---

## Phase 4 — Permission tree restoration

**Trigger**: blank module pages / only bootstrap (e.g. locale) per route → the content gate has not passed.

| Symptom | Meaning |
|---|---|
| Successfully inside the shell | Render gate + interceptor gate passed |
| Sidebar items missing/blank on click | Incomplete stub shape or permission codes |
| Same and very few APIs per route | `v-if permission` not passing |
| `routes.txt` far smaller than the bundle | Must be completed from the auth module |

```bash
grep -rhoaE '"/api[^"]*(permission|perm|role|menu|acl)[^"]*"' recon/js/*.js | sort -u | head -30
grep -rhoaE 'userRouteAuth|getResultTree|routeMap|routeLink|menuList|authList' recon/js/*.js | head -20
```

Typical chain: `role_permissions` (flat codes) + `permissions/all` (tree) → `getResultTree` → `userRouteAuth[CODE].url`. Full procedure in Reference I.

Stub checks: the outer `response_code` matches the interceptor gate; flat codes align with the tree; routes cover every link in `route_map`.

After updating the stubs, **rerun Phase 3**.

---

## Phase 5 — Merge and report

### 5b — Parameter merging

Diff from `param_samples.json`; confidence rules in Reference J7 (high/medium/low/awaiting-trigger).

### 5c — Error-driven inference

Within the authorized scope you may send incomplete requests to read 400s (**this is parameter recon, not vulnerability testing**): `field 'x' is required`, enum errors, etc. Watch for `data` wrapping, `variables`, and pre-encryption `bizData`.

The report must state: runtimeMode, static/runtime API counts, parameter confidence, uncovered modules, and any methodology adaptations made for the target.

Suggested `site_map.json` structure:

```json
{
  "site": "https://example.com",
  "runtimeMode": "both",
  "appType": "vue-spa",
  "routeGuardStrategy": ["nav-neutralize", "L1-auth", "L2-patch", "forward"],
  "apisFromStatic": [],
  "apisFromRuntime": [],
  "apis": [],
  "params": [{ "method": "POST", "path": "/api/user/list", "transport": "json", "fields": [] }],
  "frontendRoutes": [],
  "routesVerifiedByClick": [],
  "featuresTriggered": [],
  "limitations": ""
}
```

---

## General notes

- **Framework-agnostic**: webpack/Vite/Angular lazy loading works the same way
- **Transport**: REST/JSON, GraphQL, WebSocket, SSE; gRPC-web is out of scope
- **SSR**: client-side fetch is recordable; RSC/Server Actions are not fully enumerable
- **Blind spots**: JSVMP, WASM, strict HMAC/mTLS → static + note limitations
- **Parameter blind spots**: conditional coupling, hidden params, WASM payload assembly → "awaiting trigger" / "unreachable"
- **Static is the safety net**: when runtime is blocked, static can still enumerate endpoints

---

# Reference

## A. Reverse-engineering the three gates

### A1. Render gate — "how does the app decide you are logged in?"

```bash
grep -rhoaE '.{0,40}(isLogin|isAuthenticated|loggedIn|hasLogin|requireAuth)\b.{0,80}' recon/js | head
grep -rhoaE 'function (getUser|getToken|getAuth)[0-9]?\([^)]*\)\{.{0,200}' recon/js | head
grep -rhoaE '(localStorage|sessionStorage)\.getItem\("[^"]+"\)' recon/js | sort -u
grep -rhoaE '(Cookies?|cookie)\.(get|load)\("[^"]+"\)' recon/js | sort -u
grep -rhoaE '\batob\(|JSON\.parse\(|jwt|decode' recon/js | head
```

Find the chain `isLogin = f(getUser())` → `getUser = decode(storage.read(KEY))`, then pin down the **storage key**, **container** (Cookie vs localStorage), and **encoding**:

| Encoding | How to forge it |
|---|---|
| Plaintext string / `"1"` / token | any truthy value |
| `JSON.parse(x)` | `json:{"id":1,"username":"admin"}` (raw JSON) |
| `JSON.parse(atob(x))` | base64 of `{"id":1,"username":"admin"}` |
| JWT | An unsigned/`alg:none` JWT, or one signed with the key found in the bundle |
| Encrypted (SM2/AES/RSA) | Find the hardcoded key; forgeable when the render gate only needs a decodable blob; otherwise fall back to static |

### A2. Interceptor gate — "what triggers a redirect to /login?"

```bash
grep -rhoaE '.{0,60}(interceptors\.response|axios|request\.use).{0,120}' recon/js | head
grep -rhoaE '.{0,40}(response_code|errcode|errno|\bcode\b|\bret\b|\bstatus\b)\s*[=!]==?\s*[\-0-9]{1,4}.{0,60}' recon/js | head -20
grep -rhoaE '.{0,40}(not logged in|please log in again|login has expired|unauthorized|token.{0,10}invalid).{0,40}' recon/js | head
grep -rhoaE '.{0,30}(location\.href|router\.(push|replace)|navigate)\([^)]*login[^)]*\)' recon/js | head
```

Pin down the **field name**, the **success value** (usually `0` or `200`), and the **failure value that triggers the redirect**. Verify with a junk session via `send_request` before trusting the conclusion.

### A3. Content gate — "where do menus/permissions come from?"

```bash
grep -rhoaE '"/api[^"]*(permission|perm|role|menu|acl|resource|nav)[^"]*"' recon/js | sort -u
grep -rhoaE '.{0,30}(menus|permissions|menuList|routeList|authList|role_permissions)\b.{0,120}' recon/js | head
grep -rhoaE 'userRouteAuth|getResultTree|routeMap|routeLink|hasPermission|checkAuth' recon/js | head
grep -rhoaE '([A-Z_][A-Z0-9_]*):\{name:"[^"]*",link:"/[^"]+"\}' recon/js | head
```

**Two layers of data** (typical enterprise backends):

| API | Typical payload | Consumer |
|---|---|---|
| `.../role_permissions` | `{ permissions: string[], role_type }` | Route guards, button-level ACL |
| `.../permissions/all` | `tree[{ code, position, children }]` | Sidebar menu rendering |
| `userRouteAuth` in the bundle | `{ CODE: { url, name? } }` | code → frontend path |
| `routeMap` in the bundle | `{ KEY: { name, link } }` | Alias resolution (webpack `o.DASHBOARD`) |

Read the consumer code to confirm how `getResultTree(tree, permissions)` filters and which field `v-if` / `hasAuth(code)` checks. Small sites: hand-forge a permissive payload. Large sites with blank submodules: Reference I.

## E. Endpoint extraction regexes (when static yields too little)

```bash
grep -rhoaE '"/[a-z][A-Za-z0-9_/\-]{3,}"' recon/js | sort -u
grep -rhoaE '/api/[a-zA-Z0-9_./-]+' recon/js | sort -u
```

## F. Troubleshooting

| Symptom | Cause → fix |
|---|---|
| Few static APIs | Endpoint dialect mismatch → loosen the regex (E) |
| Chunk count ≪ manifest | CSS-only or undeployed chunks; 404s already retried |
| Runtime still shows the login page | Render gate is wrong → recheck A1: key name, container, encoding, domain |
| Inside the shell but modules blank | Content gate → forge menus (A3); route paths may be wrong |
| Only bootstrap/locale per route | Incomplete permission codes → Reference I permission-tree restoration |
| Every API redirects to login | Interceptor gate → confirm neutralize fields; nested fields need extended walk logic |
| Zero WS frames | Subscribes only after user interaction; linger longer per route |
| Lists all empty | L3 empty arrays are normal; keep clicking tabs/settings/details |
| Mistaking Redux actions for routes | Filter internal paths containing get/set/change/clear/toggle/upload |
| Hook lost after navigation | Full page load dropped the monkey-patch → re-inject at document start / after each `goto` |

## G. Hardened targets

When the server validates sessions step by step (signed cookies that cannot be forged, server-rendered menus that cannot be stubbed), runtime gets stuck at the shell. Expected behavior:

- **Static is enough for endpoint enumeration** — module paths are in the code
- If authorization allows, run the same flow with a **real session**: forward real requests, no neutralize, capturing real methods/params/responses

## H. Single-task checklist

1. Confirm the authorized scope
2. Static harvest → run → review `api_static.txt`, `routes.txt`
3. Phase 1b: path anchor window expansion + binding layer → `param_candidates.json`
4. Reverse-engineer A1/A2/A3 → write the site-specific stub design
5. Runtime depth or coverage with hooks installed before first navigation
6. Modules do not render → Reference I permission-tree restoration → patch stubs → rerun
7. Multi-sample parameter diff + error-driven inference → `params_merged.json`
8. Merge → `site_map.json` + `api_merged.txt`, honestly noting coverage, gaps, and adaptations

## I. Permission-tree restoration (Phase 4 deep dive)

Use when forging a simple `menus: [{ path, show: true }]` does not work and submodules still do not mount.

### I1. Locate the auth module

```bash
grep -l 'userRouteAuth' recon/js/*.js
grep -l 'routeMap\|routeLink' recon/js/*.js
grep -rhoaE 'getResultTree|role_permissions|permissions/all' recon/js | head
```

Record: **permission API paths**, **response field names**, **consuming chunk file names**.

### I2. Extract the routeMap

```bash
grep -rhoaE '([A-Z_][A-Z0-9_]*):\{name:"[^"]*",link:"/[^"]+"\}' recon/js | head -20
```

If no routeMap pattern is found: loosen the regex, or grep webpack alias tables (`o.DASHBOARD`-style minimized member maps) and resolve aliases manually.

### I3. Build the permission tree + stubs

1. Parse `userRouteAuth={MONITOR:{url:...},...}` (including webpack aliases like `He=o.DASHBOARD`)
2. Use the route map to resolve aliases → real paths
3. Infer parents from code prefixes (`MONITOR_ALERT` → `MONITOR`)
4. Output `permissions_tree.json`, `permissions_all_stub.json`, `role_permissions_stub.json` — dual stubs: flat `permissions: [codes]` for `role_permissions`, tree `{code, position, children[]}` for `permissions/all`
5. Outer field names must match the A2 interceptor gate; `permissions` must cover every leaf code in the tree

### I4. Validate stub consistency

```bash
wc -l recon/perm_codes_all.txt   # ≈ number of userRouteAuth entries
# routes should cover every link in route_map
python3 -c "import json; m=json.load(open('recon/route_map.json')); r=set(json.load(open('recon/config.json'))['routes']); print('missing', [v['link'] for v in m.values() if v['link'] not in r])"
```

### I5. Rerun runtime and compare

| Before forging | After forging (success) |
|---|---|
| The same 3–5 bootstrap calls per route | Different routes trigger different module APIs |
| Only `/api/locale/language` | `/api/web/...` module endpoints appear |
| Single-digit routes in `routes.txt` | Routes 80–110+ from route_map |

### I6. If it still fails

- **Coverage mode**: click the sidebar + tabs; permission gating may only be requested after interaction
- **Stub fields**: compare the real API (curl + real session) with the stub's nesting
- **Extra guards**: grep button-level checks such as `hasPermission|checkRole|func.` and extend `role_permissions.permissions`
- **Static fallback**: module API paths are still in `api_static.txt`, runtime only adds METHOD/body

## J. Parameter reverse engineering (Phase 1b / 5b / 5c)

**A methodology, not a universal script.** Regexes for paths; anchor window expansion + UI binding chains + multi-sample diff + error-driven inference for parameters.

### J1. Anchor window expansion

```bash
grep -n '"/api/user/list"' recon/js/*.js
grep -rhoaE '.{0,120}("/api[^"]+").{0,200}' recon/js | head
grep -rhoaE '(params|data|body|payload)\s*:\s*\{' recon/js | head
grep -rhoaE '(get|post|put|delete|patch)\([^,]+,\s*\{' recon/js | head
```

### J2. Wrapper layers and transport shapes

```bash
grep -rhoaE '(axios|request)\.(get|post|put|delete|patch)\(' recon/js | head
grep -rhoaE 'interceptors\.(request|response)' recon/js | head
grep -rhoaE '(query|mutation)\s+\w+|gql`|graphql\(' recon/js | head
grep -rhoaE '\$[a-zA-Z_]+\s*:\s*(Int|String|Boolean|\[)' recon/js | head
grep -rhoaE 'FormData|\.append\(' recon/js | head
grep -rhoaE 'path:\s*"/[^"]*:[^"]+"' recon/js | head
grep -rhoaE 'useParams|route\.params|\$route\.params' recon/js | head
```

### J3. Validation gate — required / format / enum

```bash
grep -rhoaE '(required|message|pattern|enum|validator)\s*:' recon/js | head
grep -rhoaE 'yup\.|zod\.|async-validator|Form\.Item|a-form-item|el-form-item' recon/js | head
grep -rhoaE 'rules\s*:\s*\[|name:\s*["\'][a-zA-Z_]+["\']' recon/js | head
```

### J4. Binding layer — form → API

```bash
grep -rhoaE 'onFinish|handleSubmit|getFieldsValue|validateFields' recon/js | head
grep -rhoaE '(pick|omit|transform|dayjs|moment)\(' recon/js | head
```

Runtime gap-filling: browser call stack, walk up from `fetch`/`send` to the payload-assembly function.

### J5. Encrypted parameters

```bash
grep -rhoaE 'encrypt|decrypt|sign|CryptoJS|sm2|sm3|sm4|RSA|AES' recon/js | head
```

**Do not guess fields from ciphertext** — hook the crypto function's **inputs** and record the plaintext payload before encryption.

### J6. Parameter trigger matrix (mandatory in Phase 3)

| Operation | Watch for |
|---|---|
| List first screen | Pagination defaults |
| Search | keyword, filters |
| Advanced filter | optional fields |
| Create/edit | the full entity |
| Bulk/export | `ids[]`, `exportType` |
| Sort/paginate | `sortField`, `order` |

Produces `param_samples.json`: `[{ "path", "method", "action": "search", "body", "query", "headers" }]`

### J7. Confidence rules

| Confidence | Condition |
|---|---|
| **High** | static callsite + ≥2 consistent runtime samples |
| **Medium** | static only, or just 1 runtime sample |
| **Low** | inferred from responses/errors, without a second verification |
| **Awaiting trigger** | field known statically, but the UI/permission path was never exercised |

### J8. Quick recipes per scenario

| Scenario | Sequence |
|---|---|
| REST list page | J1 payload object → J6 four diffs → J3 rules |
| Create/edit form | J3 Form name → J4 submit chain → submit at runtime + deliberately leave fields empty to see the 400 |
| GraphQL | J2 variables declarations → record variables for each operation at runtime |
| Encrypted body | J5 hook the inputs → the pre-encryption fields are the real params |

### J9. Troubleshooting

| Symptom | Fix |
|---|---|
| Field names found statically never appear at runtime | Mark "awaiting trigger"; complete the permission tree / click advanced filters / try each option of linked selects |
| Same path with different body shapes | Normal — record one entry per `action`, do not force-merge schemas |
| Stub responses are fake but you want the params | **Look at the outbound request** body/headers; do not infer from stub responses |
| 400 reports a nested field | Mind the outer wrappers `data`/`bizData`/`variables` |
| GraphQL shows only the operation name | Expand the `variables` JSON; find `$var: Type` statically |
