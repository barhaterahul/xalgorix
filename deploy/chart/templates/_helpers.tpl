{{/*
Expand the name of the chart.
*/}}
{{- define "ai-dast-ing.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields only accept that
(e.g. DNS names as per RFC 1035).
*/}}
{{- define "ai-dast-ing.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ai-dast-ing.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "ai-dast-ing.labels" -}}
helm.sh/chart: {{ include "ai-dast-ing.chart" . }}
{{ include "ai-dast-ing.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "ai-dast-ing.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ai-dast-ing.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use.
*/}}
{{- define "ai-dast-ing.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ai-dast-ing.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
ConfigMap name.
*/}}
{{- define "ai-dast-ing.configMapName" -}}
{{- printf "%s-config" (include "ai-dast-ing.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Secret name.
*/}}
{{- define "ai-dast-ing.secretName" -}}
{{- printf "%s-secret" (include "ai-dast-ing.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
