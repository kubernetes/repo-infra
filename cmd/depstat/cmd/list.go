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

	"github.com/spf13/cobra"
)

// analyzeDepsCmd represents the analyzeDeps command
var listCmd = &cobra.Command{
	Use:   "list",
	Short: "Lists all project dependencies",
	Long: `Gives a list of all the dependencies of the project. 
	These include both direct as well as transitive dependencies.`,
	RunE: func(cmd *cobra.Command, args []string) error {
		_, deps, _ := getDepInfo()
		fmt.Println("List of all dependencies:")
		printDeps(deps)
		return nil
	},
}

func init() {
	rootCmd.AddCommand(listCmd)

}
