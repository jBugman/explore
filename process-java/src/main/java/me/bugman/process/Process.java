package me.bugman.process;

import java.io.*;
import java.util.*;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.csv.CsvMapper;
import com.fasterxml.jackson.dataformat.csv.CsvParser;
import com.fasterxml.jackson.dataformat.csv.CsvSchema;

class Process {

    public static int process(String field, String folder) {
        File dir = new File(folder);
        // Glob files in folder
        File[] files = dir.listFiles(new FilenameFilter() {
            public boolean accept(File dir, String name) {
                return name.toLowerCase().endsWith(".json");
            }
        });
        HashMap<String, int[]> frequencies = new HashMap<String, int[]>();
        ObjectMapper jsonMapper = new ObjectMapper();
        for(File file: files) {
            Map data;
            // Read file as JSON
            String contents;
            try {
                data = jsonMapper.readValue(file, Map.class);
            } catch (Exception ex) {
                System.err.println(ex.getMessage());
                return 1;
            }
            if (!data.containsKey(field)) {
                System.err.println("Field is missing");
                return 1;
            }
            // Check and record field
            Object value = data.get(field);
            if (value instanceof String) {
                if (value == "") {
                    continue;
                }
                int[] iw = frequencies.get(value);
                if (iw == null) {
                    frequencies.put((String)value, new int[] { 1 });
                } else {
                    iw[0]++;
                }
            } else {
                System.err.println("Field is not a string");
                return 1;
            }
        }
        // Sort counter
        List<Map.Entry<String, int[]>> sorted = new LinkedList<Map.Entry<String, int[]>>(frequencies.entrySet());
        Collections.sort(sorted, new Comparator<Map.Entry<String, int[]>>() {
            public int compare(Map.Entry<String, int[]> o1, Map.Entry<String, int[]> o2) {
                Comparable<Integer> a = o2.getValue()[0];
                int b = o1.getValue()[0];
                return a.compareTo(b);
            }
        });
        // Convert to string arrays
        List<String[]> data = new LinkedList<String[]>();
        for(Map.Entry<String, int[]> item: sorted) {
//            System.out.printf("%s %d\n", item.getKey(), item.getValue()[0]);
            data.add(new String[]{ item.getKey(), String.valueOf(item.getValue()[0]) });
        }
        // Write result as CSV
        CsvMapper mapper = new CsvMapper();
        mapper.enable(CsvParser.Feature.WRAP_AS_ARRAY);
        File outFile = new File("output.csv");
        try {
            mapper.writeValue(outFile, data);
        } catch (IOException e) {
            System.err.println(e.getMessage());
            return 1;
        }
        return 0;
    }
}
