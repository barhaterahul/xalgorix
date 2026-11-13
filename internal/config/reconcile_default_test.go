package config

import "testing"

// Converge-reconcile is on unless explicitly disabled.
func TestConvergeReconcileDefaultsOn(t *testing.T) {
	isolateEnvFiles(t)
	t.Setenv("AIDASTING_CONVERGE_RECONCILE", "")
	if !load().ConvergeReconcile {
		t.Fatal("ConvergeReconcile default = false, want true")
	}
	t.Setenv("AIDASTING_CONVERGE_RECONCILE", "false")
	if load().ConvergeReconcile {
		t.Fatal("AIDASTING_CONVERGE_RECONCILE=false did not disable converge-reconcile")
	}
}
