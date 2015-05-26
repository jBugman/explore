package process

import (
	"encoding/csv"
	"encoding/json"
	"errors"
	"io/ioutil"
	"os"
	"path/filepath"
	"sort"
	"strconv"
)

const outputFileName string = "output.csv"

func Run(field, folder string) error {
	files, err := filepath.Glob(folder + "*.json")
	if err != nil {
		return err
		// log.Fatal(err)
	}

	frequencies := make(map[string]int)

	for _, file := range files {
		bytes, err := ioutil.ReadFile(file)
		if err != nil {
			// log.Fatal(err)
			return err
		}

		var data map[string]interface{}
		if err := json.Unmarshal(bytes, &data); err != nil {
			// log.Fatal(err, file)
			return err
		}

		if value, ok := data[field]; !ok {
			return errors.New("Field is missing")
			// log.Fatal("Field is missing")
		} else {
			switch x := value.(type) {
			case string:
				if x != "" {
					frequencies[x]++
				}
			default:
				return errors.New("Field is not a string")
				// log.Fatal("Field is not a string")
			}
		}
	}

	outputFile, err := os.Create(outputFileName)
	if err != nil {
		// panic(err)
		return err
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
	// return csvWriter.Error()
	return nil
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
