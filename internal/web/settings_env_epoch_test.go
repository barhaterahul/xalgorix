package web

import "testing"

// The dashboard shows and applies epoch coverage as on by default.
func TestEpochCoverageSettingDefaultsOn(t *testing.T) {
	def, ok := envDefinitionByKey()["AIDASTING_EPOCH_COVERAGE"]
	if !ok || def.DefaultValue != "true" {
		t.Fatalf("AIDASTING_EPOCH_COVERAGE definition = %+v, want default true", def)
	}
	s := newTestServer(t, nil)
	s.cfg.EpochCoverage = false
	s.applyEnvironmentToRuntimeConfig(map[string]string{"AIDASTING_EPOCH_COVERAGE": ""})
	if !s.cfg.EpochCoverage {
		t.Fatal("an empty AIDASTING_EPOCH_COVERAGE did not fall back to the default (true)")
	}
}
