/*
Copyright 2021 The Kubernetes Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package cmd

import (
	"encoding/json"
	"fmt"

	"github.com/spf13/cobra"
)

var jsonOutputCycles bool

// analyzeDepsCmd represents the analyzeDeps command
var cyclesCmd = &cobra.Command{
	Use:   "cycles",
	Short: "Prints cycles in dependency chains.",
	Long:  `Will show all the cycles in the dependencies of the project.`,
	RunE: func(cmd *cobra.Command, args []string) error {
		depGraph, _, mainModule := getDepInfo()
		var cycleChains [][]string
		chains := make(map[int][]string)
		var temp []string
		getChains(mainModule, depGraph, temp, chains, &cycleChains)
		cycles := getCycles(cycleChains)

		if !jsonOutputCycles {
			fmt.Println("All cycles in dependencies are: ")
			for _, c := range cycles {
				printChain(c)
			}
		} else {
			// create json
			outputObj := struct {
				Cycles [][]string `json:"cycles"`
			}{
				Cycles: cycles,
			}
			outputRaw, err := json.MarshalIndent(outputObj, "", "\t")
			if err != nil {
				return err
			}
			fmt.Println(string(outputRaw))
		}
		return nil
	},
}

// gets the cycles from the cycleChains
func getCycles(cycleChains [][]string) [][]string {
	var cycles [][]string
	for _, cycle := range cycleChains {
		var actualCycle []string
		start := false
		startDep := cycle[len(cycle)-1]
		for _, val := range cycle {
			if val == startDep {
				start = true
			}
			if start {
				actualCycle = append(actualCycle, val)
			}
		}
		if !sliceContains(cycles, actualCycle) {
			cycles = append(cycles, actualCycle)
		}
	}
	return cycles
}

func init() {
	rootCmd.AddCommand(cyclesCmd)
	cyclesCmd.Flags().BoolVarP(&jsonOutputCycles, "json", "j", false, "Get the output in JSON format")
}
