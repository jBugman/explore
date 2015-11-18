.PHONY: build run

	# javac -d out/production -sourcepath src src/me/bugman/process/*.java
	# jar cvfe out/process.jar me.bugman.process.Main -C out/production/ .
build:
	gradle build

	# java -classpath out/production/ me.bugman.process.Main Name ../test_data/
run:
	java -jar build/libs/process.jar Name ../test_data/
