package me.bugman.process;

class Main {

    public static void main(String[] args) {
        for(int i = 0; i < 100; i++) {
            Process.process("Name", "../test_data/");
        }
    }
}
