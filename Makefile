.PHONY: run-tests

run-tests: test.so test.p6
	LD_LIBRARY_PATH=. perl6 test.p6

test.so: test.c
	$(CC) -shared -fPIC -o $@ $^

