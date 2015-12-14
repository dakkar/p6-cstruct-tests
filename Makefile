test.so: test.c
	$(CC) -shared -fPIC -o $@ $^
