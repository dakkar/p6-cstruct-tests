Some random tests of `CStruct` and `NativeCall`
-----------------------------------------------

To run:

    make run-tests

(only tested in Linux, rakudo-moar, gcc)

What it tests:

1. that you can subclass a `CStruct`
2. that the memory layout is "the obvious one"
3. that you can mutate strings and have them seen at the C level

What I'd also like to test:

1. what happens to `Str` that map `char*` allocated with a different
   size
2. how / when destructors are called
