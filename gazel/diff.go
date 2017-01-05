package main

import (
	"io/ioutil"
	"os"
	"os/exec"
)

func Diff(left, right []byte) error {
	lf, err := ioutil.TempFile("/tmp", "gazel-diff")
	if err != nil {
		return err
	}
	defer lf.Close()
	defer os.Remove(lf.Name())

	rf, err := ioutil.TempFile("/tmp", "gazel-diff")
	if err != nil {
		return err
	}
	defer rf.Close()
	defer os.Remove(rf.Name())

	_, err = lf.Write(left)
	if err != nil {
		return err
	}
	lf.Close()

	_, err = rf.Write(right)
	if err != nil {
		return err
	}
	rf.Close()

	cmd := exec.Command("/usr/bin/diff", lf.Name(), rf.Name())
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()

	return nil
}
