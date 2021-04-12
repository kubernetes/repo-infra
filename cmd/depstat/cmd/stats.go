package cmd

import (
	"encoding/json"
	"fmt"

	"github.com/spf13/cobra"
)

var jsonOutput bool
var verbose bool

// statsCmd represents the statsDeps command
var statsCmd = &cobra.Command{
	Use:   "stats",
	Short: "Shows metrics about dependency chains",
	Long: `Provides the following metrics:
	1. Total Dependencies: Total number of dependencies of the project
	2. Max Depth of Dependencies: Number of dependencies in the longest dependency chain
	3. Transitive Dependencies: Total number of transitive dependencies (dependencies which are not direct dependencies of the project)`,
	RunE: func(cmd *cobra.Command, args []string) error {
		depGraph, deps, mainModule := getDepInfo()

		// Get all chains starting from main module
		// also get all cycles
		// cycleChains stores the chain containing the cycles and
		// not the actual cycle itself
		var cycleChains [][]string
		chains := make(map[int][]string)
		var temp []string
		getChains(mainModule, depGraph, temp, chains, &cycleChains)

		// get values
		totalDeps := len(deps)
		maxDepth := getMaxDepth(chains)
		directDeps := len(depGraph[mainModule])
		transitiveDeps := totalDeps - directDeps

		if !jsonOutput {
			fmt.Printf("Total Dependencies: %d \n", totalDeps)
			fmt.Printf("Max Depth Of Dependencies: %d \n", maxDepth)
			fmt.Printf("Transitive Dependencies: %d \n", transitiveDeps)
		}

		if verbose {
			fmt.Println("All dependencies:")
			printDeps(deps)
		}

		// print the longest chain
		if verbose {
			fmt.Println("Longest chain is: ")
			printChain(chains[maxDepth])
		}

		if jsonOutput {
			// create json
			outputObj := struct {
				TotalDeps int `json:"totalDependencies"`
				MaxDepth  int `json:"maxDepthOfDependencies"`
				TransDeps int `json:"transitiveDependencies"`
			}{
				TotalDeps: totalDeps,
				MaxDepth:  maxDepth,
				TransDeps: transitiveDeps,
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

// get the length of the longest dependency chain
func getMaxDepth(chains map[int][]string) int {
	maxDeps := 0
	for deps := range chains {
		maxDeps = max(maxDeps, deps)
	}
	// for A -> B -> C the depth is 3
	return maxDeps
}

func init() {
	rootCmd.AddCommand(statsCmd)
	statsCmd.Flags().BoolVarP(&verbose, "verbose", "v", false, "Get additional details")
	statsCmd.Flags().BoolVarP(&jsonOutput, "json", "j", false, "Get the output in JSON format")
}
