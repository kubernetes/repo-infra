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
