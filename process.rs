use std::env;

const OUTPUT_FILE: &'static str = "output.csv";

fn main() {
	let args: Vec<String>= env::args().collect();

	if args.len() < 3 {
		panic!("Args are: <field name> <folder>");
	}

	let field = &args[1];
	let folder = &args[2];
	println!("Will process field '{}' in files located in {}", field, folder);
}