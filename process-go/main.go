package main

import "./process"
import (
	"log"
	"os"
)

func main() {
	args := os.Args
	if len(args) < 3 {
		log.Fatal("Args are: <field name> <folder>")
	}
	if err := process.Run(args[1], args[2]); err != nil {
		log.Fatal(err)
	}
}

// // Benchmark
// func main() {
// 	_, _ = log.Fatal, os.Args
// 	for i := 0; i < 100; i++ {
// 		process.Run("Name", "../test_data/")
// 	}
// }
