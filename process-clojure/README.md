	lein run -- Name ../test_data/

	lein test

	lein uberjar
	java -jar target/uberjar/process-0.1.0-standalone.jar Name ../test_data/
