package config

import (
	"os"
	"path/filepath"
	"slices"
	"testing"
)

// The guard list is resolved at package load, so it holds the HOME the test
// binary started with, not a temp HOME a test sets later.
func TestAccountEnvFilesIncludeStartingHome(t *testing.T) {
	if !slices.Contains(accountEnvFiles, "/root/.ai-dast-ing.env") {
		t.Errorf("accountEnvFiles = %v, want /root/.ai-dast-ing.env", accountEnvFiles)
	}
	home, err := os.UserHomeDir()
	if err != nil || home == "" {
		t.Skip("no HOME in this environment")
	}
	if want := filepath.Join(home, ".ai-dast-ing.env"); !slices.Contains(accountEnvFiles, want) {
		t.Errorf("accountEnvFiles = %v, want %s", accountEnvFiles, want)
	}
}

// UpdateEnvFile must refuse, in a test binary, to write an env file of the
// account running the tests, however the path reaches it. A sentinel file
// stands in for the real one so a broken guard only damages a temp dir.
func TestUpdateEnvFileRefusesAccountEnvFile(t *testing.T) {
	realHome := t.TempDir()
	sentinel := filepath.Join(realHome, ".ai-dast-ing.env")
	const original = "AIDASTING_API_KEY=production-key\n"
	if err := os.WriteFile(sentinel, []byte(original), 0o600); err != nil {
		t.Fatal(err)
	}
	prev := accountEnvFiles
	accountEnvFiles = []string{sentinel}
	t.Cleanup(func() { accountEnvFiles = prev })

	linkDir := filepath.Join(t.TempDir(), "home-link")
	if err := os.Symlink(realHome, linkDir); err != nil {
		t.Fatal(err)
	}
	hardLink := filepath.Join(t.TempDir(), ".ai-dast-ing.env")
	if err := os.Link(sentinel, hardLink); err != nil {
		t.Fatal(err)
	}
	t.Chdir(realHome)

	for name, path := range map[string]string{
		"exact path":        sentinel,
		"unclean path":      filepath.Join(realHome, ".", ".ai-dast-ing.env"),
		"relative path":     ".ai-dast-ing.env",
		"via symlinked dir": filepath.Join(linkDir, ".ai-dast-ing.env"),
		"hard link to it":   hardLink,
	} {
		if err := UpdateEnvFile(path, map[string]string{"AIDASTING_API_KEY": "dup-key-1111"}); err == nil {
			t.Errorf("%s: UpdateEnvFile(%s) succeeded, want refusal", name, path)
		}
	}
	data, err := os.ReadFile(sentinel)
	if err != nil {
		t.Fatal(err)
	}
	if string(data) != original {
		t.Fatalf("protected env file changed to %q", data)
	}

	// A protected file that does not exist yet can't be matched by inode, so
	// the path itself must resolve: ".." through a symlink follows the link
	// first, as the kernel does.
	absentHome := t.TempDir()
	if err := os.Mkdir(filepath.Join(absentHome, "sub"), 0o700); err != nil {
		t.Fatal(err)
	}
	subLink := filepath.Join(t.TempDir(), "sub-link")
	if err := os.Symlink(filepath.Join(absentHome, "sub"), subLink); err != nil {
		t.Fatal(err)
	}
	absent := []string{filepath.Join(absentHome, ".ai-dast-ing.env")}
	// Built by hand: filepath.Join would drop "sub-link/.." lexically.
	if err := refuseAccountEnvFile(subLink+"/../.ai-dast-ing.env", absent); err == nil {
		t.Error("path with .. through a symlinked dir was not refused")
	}
	if err := refuseAccountEnvFile(filepath.Join(subLink, ".ai-dast-ing.env"), absent); err != nil {
		t.Errorf("unrelated path refused: %v", err)
	}

	// Any other path, such as a temp HOME's env file, still works.
	other := filepath.Join(t.TempDir(), ".ai-dast-ing.env")
	if err := UpdateEnvFile(other, map[string]string{"AIDASTING_API_KEY": "test-key"}); err != nil {
		t.Fatalf("UpdateEnvFile(temp path): %v", err)
	}
	if got, _ := ReadEnvFile(other); got["AIDASTING_API_KEY"] != "test-key" {
		t.Fatalf("temp env file = %v", got)
	}
}
