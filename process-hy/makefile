install:
	virtualenv -p python3 env
	source env/bin/activate
	pip install hy

run_direct:
	hy process.hy Name ../test_data/

run:
	hyc process.hy
	python3 process.pyc Name ../test_data/
