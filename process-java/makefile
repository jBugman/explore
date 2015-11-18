.PHONY: build run

### Left as cheat-sheet
## Manually build jar
# javac -d out/production -sourcepath src src/me/bugman/process/*.java
# jar cvfe out/process.jar me.bugman.process.Main -C out/production/ .
## Run jar
# java -classpath out/production/ me.bugman.process.Main Name ../test_data/

build:
	gradle fatjar

run:
	java -jar build/libs/process.jar Name ../test_data/
