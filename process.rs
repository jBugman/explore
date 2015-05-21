extern crate glob;
extern crate rustc_serialize;

use glob::glob;
use rustc_serialize::json::Json;
use std::env;
use std::fs::File;
use std::result::Result;
use std::io::Read;
use std::collections::HashMap;
use std::string::as_string;

/***

To much 'unstable' to continue yet=(

***/


// const OUTPUT_FILE: &'static str = "output.csv";

fn main() {

	let args: Vec<String>= env::args().collect();

	if args.len() < 3 {
		panic!("Args are: <field name> <folder>");
	}

	let field = &args[1];
	let folder = &args[2];

	let mut frequencies = HashMap::new();

	let search_path = format!("{}/*.json", folder);
	let file_paths = glob(&search_path).unwrap();
	for path in file_paths.filter_map(Result::ok) {

		let path = path.to_str().unwrap();
		let contents = file_contents(path);

		let data = Json::from_str(&contents).ok();
		let data = data.expect("Malformed JSON");
		// let value = data.find(field).expect("Field is missing");
		// let key = value.as_string().expect("Field is not a string");
		let key = get_string_value(&data, field);

		let counter = match frequencies.get(&key) {
			None => 0,
			Some(&x) => x,
		};
		frequencies.insert(key, counter + 1);

		// let counter = value_option.unwrap_or(0);
		// frequencies.insert(key, *counter + 1);
	}

}

fn get_string_value(json: &Json, key: &str) -> String {
	let value = json.find(key).expect("Field is missing");
	let result = value.as_string().expect("Field is not a string");
	as_string(result)
}

fn file_contents(file_path: &str) -> String {
	let mut file = File::open(file_path).ok().expect("Failed to open file");
	let mut contents = String::new();
	file.read_to_string(&mut contents).ok().expect("Failed to read file");
	contents
}