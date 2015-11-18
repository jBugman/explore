package me.bugman.process;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;

class Process {

    private static String readFile(File f) throws IOException {
        byte[] encoded = Files.readAllBytes(f.toPath());
        return new String(encoded, StandardCharsets.UTF_8);
    }

    public static int process(String field, String folder) {
        File dir = new File(folder);
        // Glob files in folder
        File[] files = dir.listFiles(new FilenameFilter() {
            public boolean accept(File dir, String name) {
                return name.toLowerCase().endsWith(".json");
            }
        });
        for(File file: files) {
            // Read file as string
            String contents;
            try {
                contents = readFile(file);
            } catch (IOException ex) {
                System.err.println(ex.getMessage());
                return 1;
            }
            //
            System.out.println(contents);
        }
        return 0;
    }
}
