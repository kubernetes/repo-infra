package main

import "testing"

func TestExtractDebPackageName(t *testing.T) {
	cases := []struct{
		metadata byte[]
		filename string
		expectedPackageName string
	}{
		{
			byte[]("Package: test\nDescription: Dummy\nVersion: 1.2.4"),
			"valid-deb.deb",
			"test",
		},
		{
			byte[]{"InvalidPackageMetadata: InvalidName"},
			"path/test-invalid-pkg.deb",
			"test-invalid-pkg",
		},
	}
	for _, c := range cases {
		packageName := extractDebPackageName(c.metadata, c.filename)
		if packageName != c.expectedPackageName {
			t.Errorf("Expected %v, got %v", c.expectedPackageName, packageName)
		}
	}
}