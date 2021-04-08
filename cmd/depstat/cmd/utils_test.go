package cmd

import (
	"testing"
)

func Test_getChains_simple(t *testing.T) {

	/*
		Graph:
				  A
				/ | \
			   B  C  D
				\/   |
				E	 G
				|
				F
				|
				H
	*/

	graph := make(map[string][]string)
	graph["A"] = []string{"B", "C", "D"}
	graph["B"] = []string{"E"}
	graph["C"] = []string{"E"}
	graph["D"] = []string{"G"}
	graph["E"] = []string{"F"}
	graph["F"] = []string{"H"}

	var cycleChains [][]string
	chains := make(map[int][]string)
	var temp []string
	getChains("A", graph, temp, chains, &cycleChains)
	maxDepth := getMaxDepth(chains)
	cycles := getCycles(cycleChains)

	if len(cycles) != 0 {
		t.Errorf("There should be no cycles")
	}

	if maxDepth != 5 {
		t.Errorf("Max depth of dependencies was incorrect")
	}

	longestPath := []string{"A", "C", "E", "F", "H"}

	if !isSliceSame(chains[maxDepth], longestPath) {
		t.Errorf("Longest path was incorrect")
	}
}

func Test_getChains_cycle(t *testing.T) {

	/*
		Graph:
					 A
				   /   \
				  B     C
				  |     |
				  D 	E
				/   \
				H	F
				 \ /
				  G
	*/

	graph := make(map[string][]string)
	graph["A"] = []string{"B", "C"}
	graph["B"] = []string{"D"}
	graph["C"] = []string{"E"}
	graph["D"] = []string{"F"}
	graph["F"] = []string{"G"}
	graph["G"] = []string{"H"}
	graph["H"] = []string{"D"}

	var cycleChains [][]string
	chains := make(map[int][]string)
	var temp []string
	getChains("A", graph, temp, chains, &cycleChains)
	maxDepth := getMaxDepth(chains)
	cycles := getCycles(cycleChains)

	cyc := []string{"D", "F", "G", "H", "D"}

	if len(cycles) != 1 {
		t.Errorf("Number of cycles is not correct")
	}

	if !isSliceSame(cycles[0], cyc) {
		t.Errorf("Cycle is not correct")
	}

	if maxDepth != 6 {
		t.Errorf("Max depth of dependencies was incorrect")
	}

	longestPath := []string{"A", "B", "D", "F", "G", "H"}
	if !isSliceSame(chains[maxDepth], longestPath) {
		t.Errorf("Longest path was incorrect")
	}
}

func Test_getChains_cycle_2(t *testing.T) {

	/*
		Graph:
					 A
				   /  |
				  B   |
				 ||   |
				  C --
				/   \
				D	E
				 \ /
				  F
	*/

	graph := make(map[string][]string)
	graph["A"] = []string{"B", "C"}
	graph["B"] = []string{"C"}
	graph["C"] = []string{"B", "E"}
	graph["E"] = []string{"F"}
	graph["F"] = []string{"D"}
	graph["D"] = []string{"C"}

	var cycleChains [][]string
	chains := make(map[int][]string)
	var temp []string
	getChains("A", graph, temp, chains, &cycleChains)
	maxDepth := getMaxDepth(chains)

	cycles := getCycles(cycleChains)

	if maxDepth != 6 {
		t.Errorf("Max depth of dependencies was incorrect")
	}

	if len(cycles) != 3 {
		t.Errorf("Number of cycles is incorrect")
	}
	cyc1 := []string{"B", "C", "B"}
	cyc2 := []string{"C", "E", "F", "D", "C"}
	cyc3 := []string{"C", "B", "C"}

	if !isSliceSame(cycles[0], cyc1) {
		t.Errorf("B C B cycle is incorrect")
	}

	if !isSliceSame(cycles[1], cyc2) {
		t.Errorf("C E F D C cycle is incorrect")
	}

	if !isSliceSame(cycles[2], cyc3) {
		t.Errorf("C B C cycle is incorrect")
	}

	longestPath := []string{"A", "B", "C", "E", "F", "D"}
	if !isSliceSame(chains[maxDepth], longestPath) {
		t.Errorf("Longest path was incorrect")
	}
}

// order matters
func Test_isSliceSame_Pass(t *testing.T) {
	a := []string{"A", "B", "C", "D"}
	b := []string{"A", "B", "C", "D"}
	if !isSliceSame(a, b) {
		t.Errorf("Slices should have been same")
	}
}

func Test_isSliceSame_Fail(t *testing.T) {
	a := []string{"A", "B", "C", "D"}
	b := []string{"A", "B", "D", "C"}
	if isSliceSame(a, b) {
		t.Errorf("Slices should have been different")
	}
}

func Test_sliceContains_Pass(t *testing.T) {
	var a [][]string
	a = append(a, []string{"A", "B", "C"})
	a = append(a, []string{"B", "C"})
	a = append(a, []string{"C", "A", "B"})
	b := []string{"B", "C"}
	if !sliceContains(a, b) {
		t.Errorf("Slice a should have b")
	}
}

func Test_sliceContains_Fail(t *testing.T) {
	var a [][]string
	a = append(a, []string{"A", "B", "C"})
	a = append(a, []string{"B", "C"})
	a = append(a, []string{"C", "A", "B"})
	b := []string{"E", "C"}
	if sliceContains(a, b) {
		t.Errorf("Slice a should not have b")
	}
}
