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
