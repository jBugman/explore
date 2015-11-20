package me.bugman.process;

class Main {

    public static void main(String[] args) {
        if (args.length != 2) {
            System.err.println("Args are: <field name> <folder>");
            System.exit(0);
        }
        Process.process(args[0], args[1]);
    }

    // // Benchmark
    // public static void main(String[] args) {
    //     for(int i = 0; i < 100; i++) {
    //         Process.process("Name", "../test_data/");
    //     }
    // }
}
