extern crate glob;
extern crate rustc_serialize;
extern crate csv;

use glob::glob;
use rustc_serialize::json::Json;
use std::env;
use std::fs::File;
use std::result::Result;
use std::io::Read;
use std::collections::HashMap;
use std::error::Error;


const OUTPUT_FILE: &'static str = "output.csv";

#[allow(dead_code)]
fn main() {
	let args: Vec<String>= env::args().collect();

	if args.len() < 3 {
		panic!("Args are: <field name> <folder>");
	}

	let field = &args[1];
	let folder = &args[2];
	process(field, folder);
}

fn process(field: &str, folder: &str) -> bool {
	let mut frequencies: HashMap<String, i64> = HashMap::new();

	let search_path = format!("{}/*.json", folder);
	let file_paths = glob(&search_path).unwrap();
	for path in file_paths.filter_map(Result::ok) {
		let path = path.to_str().unwrap();

		let contents = file_contents(path);
		let data = Json::from_str(&contents).ok().expect("Malformed JSON");

		let key = get_string_value(&data, field);
		let counter = match frequencies.get(&key) {
			None => 0,
			Some(&x) => x,
		};
		frequencies.insert(key, counter + 1);
	}

	let mut sorted_frequencies: Vec<(&String, &i64)> = frequencies.iter().collect();
	sorted_frequencies.sort_by(|a, b| a.1.cmp(b.1).reverse());

	let mut csv_writer = match csv::Writer::from_file(OUTPUT_FILE) {
		Err(why) => panic!("Failed to create CSV writer: {}", Error::description(&why)),
		Ok(x) => x,
	};
	for record in sorted_frequencies.iter().filter(|&x| x.0 != "") {
		let result = csv_writer.encode(record);
		assert!(result.is_ok());
	};

	true
}

fn get_string_value(json: &Json, key: &str) -> String {
	let value = json.find(key).expect("Field is missing");
	let result = value.as_string().expect("Field is not a string");
	result.to_string()
}

fn file_contents(file_path: &str) -> String {
	let mut file = match File::open(file_path) {
		Err(why) => panic!("Failed to open {}: {}", file_path, Error::description(&why)),
		Ok(file) => file,
	};
	let mut contents = String::new();
	match file.read_to_string(&mut contents) {
		Err(why) => panic!("Failed to read {}: {}", file_path, Error::description(&why)),
		Ok(_) => contents,
	}
}

#[test]
fn it_works() {
	assert!(process("Name", "../../test_data"));
}
