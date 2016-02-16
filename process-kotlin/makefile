.PHONY: build

# kotlinc process.kt -include-runtime -d build/process.jar
build:
	gradle fatjar

run:
	java -jar build/libs/process.jar Name ../test_data/

test:
	gradle test
