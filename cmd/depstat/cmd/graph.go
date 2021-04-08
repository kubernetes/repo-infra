package cmd

import (
	"fmt"
	"io/ioutil"

	"github.com/spf13/cobra"
)

var graphCmd = &cobra.Command{
	Use:   "graph",
	Short: "Generate a .dot file to be used with Graphviz's dot command.",
	Long: `A graph.dot file will be generated which can be used with Graphviz's dot command.
	For example to generate a svg image use:
	twopi -Tsvg -o dag.svg graph.dot`,
	RunE: func(cmd *cobra.Command, args []string) error {
		depGraph, deps, _ := getDepInfo()
		fileContents := "digraph {\ngraph [rankdir=TB, overlap=false];\n"
		for _, dep := range deps {
			_, ok := depGraph[dep]
			if !ok {
				continue
			}
			for _, neighbour := range depGraph[dep] {
				fileContents += fmt.Sprintf("\"%s\" -> \"%s\"\n", dep, neighbour)
			}
		}
		fileContents += "}"
		fileContentsByte := []byte(fileContents)
		err := ioutil.WriteFile("./graph.dot", fileContentsByte, 0644)
		if err != nil {
			return err
		}
		fmt.Println("\nCreated graph.dot file!")
		return nil
	},
}

func init() {
	rootCmd.AddCommand(graphCmd)
}
