#!/usr/bin/env python3
from collections import Counter
import csv
import json
import sys
import os
import os.path


def process(field, folder):
    frequencies = Counter()
    files = [f for f in os.listdir(folder) if f.endswith('.json')]
    for file in files:
        with open(os.path.join(folder, file), encoding='utf-8') as jsonfile:
            json_data = json.load(jsonfile)
            if field not in json_data:
                sys.exit('Field is missing')

            value = json_data[field]
            if not isinstance(value, str):
                sys.exit('Field is not a string')

            if value != '':
                frequencies[value] += 1

    with open('output.csv', 'w', encoding='utf-8') as csvfile:
        csvwriter = csv.writer(csvfile)
        for item in frequencies.most_common():
            csvwriter.writerow(item)


if __name__ == '__main__':
    if len(sys.argv) < 3:
        print('Args are: <field name> <folder>')
    else:
        process(sys.argv[1], sys.argv[2])

# Benchmark
# if __name__ == '__main__':
#     for i in range(100):
#         process("Name", "../test_data/")
