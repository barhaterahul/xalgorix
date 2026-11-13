package config

import "testing"

// Epoch-based coverage convergence is on unless explicitly disabled.
func TestEpochCoverageDefaultsOn(t *testing.T) {
	isolateEnvFiles(t)
	t.Setenv("AIDASTING_EPOCH_COVERAGE", "")
	if !load().EpochCoverage {
		t.Fatal("EpochCoverage default = false, want true")
	}
	t.Setenv("AIDASTING_EPOCH_COVERAGE", "false")
	if load().EpochCoverage {
		t.Fatal("AIDASTING_EPOCH_COVERAGE=false did not disable epoch coverage")
	}
}
