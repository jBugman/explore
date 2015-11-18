package me.bugman.process;

class Main {

    public static void main(String[] args) {
        if (args.length != 2) {
            System.err.println("Args are: <field name> <folder>");
            System.exit(0);
        }
        Process.process(args[0], args[1]);
    }
}
