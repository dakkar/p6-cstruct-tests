#!rakudo
use v6;

my class One is repr('CStruct') {
    has int32 $.int;

    sub new_one(int32) returns One is native('test');
    sub print_one() is native('test');
    sub free_one(One) is native('test');

    method new(Int $x) {
        return new_one($x);
    }

    method print() {
        print_one(self);
    }

    submethod DESTROY() {
        free_one(self);
    }
}

my class Two is One {
    has Str $.str;

    sub new_two(int32,Str) returns Two is native('test');
    sub print_two() is native('test');
    sub free_two(Two) is native('test');

    method new(Int $x,Str $y) {
        return new_two($x,$y);
    }

    method print() {
        print_two(self);
    }

    submethod DESTROY() {
        free_two(self);
    }
}

my One $x .= new(int=>12);
$x.print;
