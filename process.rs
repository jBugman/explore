extern crate glob;
extern crate rustc_serialize;

use glob::glob;
use rustc_serialize::json::Json;
use std::env;
use std::fs::File;
use std::result::Result;
use std::io::Read;


// const OUTPUT_FILE: &'static str = "output.csv";

fn main() {
	let args: Vec<String>= env::args().collect();

	if args.len() < 3 {
		panic!("Args are: <field name> <folder>");
	}

	let field = &args[1];
	let folder = &args[2];
	// println!("Will process field '{}' in files located in {}", field, folder);

	let search_path = format!("{}/*.json", folder);
	for path in glob(&search_path).unwrap().filter_map(Result::ok) {
		// println!("{}", path.display());
		let mut file = File::open(&path).unwrap();
		let mut contents = &mut String::new();
		file.read_to_string(contents).ok().expect("Failed to read file");

		let data = Json::from_str(&contents).unwrap();
		let value = data.find(field).expect("Field is missing");
		match value.as_string() {
			Some(_) => (),
			None => panic!("Field is not string"),
		}
	}
}
