package main

import (
	"encoding/csv"
	"encoding/json"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"sort"
	"strconv"
)

const outputFileName string = "output.csv"

func main() {
	args := os.Args
	if len(args) < 3 {
		log.Fatal("Args are: <field name> <folder>")
	}
	field := args[1]
	folder := args[2]

	files, err := filepath.Glob(folder + "*.json")
	if err != nil {
		log.Fatal(err)
	}

	frequencies := make(map[string]int)

	for _, file := range files {
		bytes, err := ioutil.ReadFile(file)
		if err != nil {
			log.Fatal(err)
		}
		var data map[string]interface{}
		if err := json.Unmarshal(bytes, &data); err != nil {
			log.Fatal(err, file)
		}
		if value, ok := data[field]; !ok {
			log.Fatal("Field is missing")
		} else {
			switch x := value.(type) {
			case string:
				frequencies[x]++
			default:
				log.Fatal("Field is not a string")
			}
		}
	}

	outputFile, err := os.Create(outputFileName)
	if err != nil {
		panic(err)
	}
	defer outputFile.Close()

	csvWriter := csv.NewWriter(outputFile)

	sortedFrequencies := sortMapByValue(frequencies)
	for _, item := range sortedFrequencies {
		line := []string{
			item.Key,
			strconv.Itoa(item.Value),
		}
		csvWriter.Write(line)
	}
	csvWriter.Flush()
}

/*
 * Batteries not included=(
 * Andrew Gerrand's solution
 */

// A data structure to hold a key/value pair.
type Pair struct {
	Key   string
	Value int
}

// A slice of Pairs that implements sort.Interface to sort by Value.
type PairList []Pair

func (p PairList) Swap(i, j int)      { p[i], p[j] = p[j], p[i] }
func (p PairList) Len() int           { return len(p) }
func (p PairList) Less(i, j int) bool { return p[i].Value > p[j].Value } // Actually 'more'

// A function to turn a map into a PairList, then sort and return it.
func sortMapByValue(m map[string]int) PairList {
	p := make(PairList, len(m))
	i := 0
	for k, v := range m {
		p[i] = Pair{k, v}
		i++
	}
	// log.Println(&p)
	sort.Sort(p)
	return p
}
