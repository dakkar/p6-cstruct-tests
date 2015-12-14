#!rakudo
use v6;
use NativeCall;
use Test;

sub cmp-deeply(Mu $got, Mu $expected, $reason = '') {
    my $test = $got ~~ $expected;
    my $ok = ok($test, $reason);
    if !$test {
        my $got_perl      = try { $got.perl };
        my $expected_perl = try { $expected.perl };
        if $got_perl.defined && $expected_perl.defined {
            diag "expected: $expected_perl";
            diag "     got: $got_perl";
        }
    }
    $ok;
}

my @events;
sub get_destroys() returns Str is native('test') {*}
sub clear_destroys() is native('test') {*}

sub get_events {
    (@events,get_destroys.split(/\n/)).flat.grep(*.chars);
}
sub clear_events {
    @events=();
    clear_destroys();
}

my class One is repr('CStruct') {
    has int32 $.int is rw;

    sub new_one(int32) returns One is native('test') {*};
    sub string_one(One) returns Str is native('test') {*};
    sub free_one(One) is native('test') {*};

    method new(Int $x) {
        return new_one($x);
    }

    method Str() {
        string_one(self);
    }

    method perl_string() {
        return "Perl {self.^name} int: {self.int}\n";
    }
    
    submethod DESTROY() {
        push @events,sprintf('One.DESTROY(0x%x)',self.WHERE);
        free_one(self);
    }
}

my class Two is One is repr('CStruct') {
    has Str $.str;

    sub new_two(int32,Str) returns Two is native('test') {*};
    sub string_two(Two) returns Str is native('test') {*};
    sub free_two(Two) is native('test') {*};

    method str is rw {
        Proxy.new(
            FETCH => { $!str },
            STORE => -> $, Str $x { $!str := $x; $!str },
        );
    }
    
    method new(Int $x,Str $y) {
        return new_two($x,$y);
    }

    method Str() {
        string_two(self);
    }

    method perl_string() {
        callsame() ~ "Perl {self.^name} str: {self.str}\n";
    }

    submethod DESTROY() {
        push @events,sprintf('Two.DESTROY(0x%x)',self.WHERE);
        free_two(self);
    }
}

{
    my One $x .= new(12);
    is(
        $x.Str,
        "One int: 12\n",
        'C stringification should work',
    );
    is(
        $x.perl_string,
        "Perl One int: 12\n",
        'Perl stringification should work',
    );

    cmp-deeply(
        get_events(),
        (),
        'no destructors should have been called yet',
    );
    clear_events;
    $x.DESTROY;
    cmp-deeply(
        get_events(),
        (rx{^One\.DESTROY},rx{^free_one}),
        'Perl and C destructors should have been called',
    );
    clear_events;
}

{
    my Two $y .= new(15,"foo");
    is(
        $y.Str,
        "Two int: 15\nTwo str: foo\n",
        'C stringification should work',
    );
    is(
        $y.perl_string,
        "Perl Two int: 15\nPerl Two str: foo\n",
        'Perl stringification should work',
    );

    $y.int = 37;
    $y.str = "bar";
    is(
        $y.Str,
        "Two int: 37\nTwo str: bar\n",
        'C stringification should work after modifying attributes',
    );
    is(
        $y.perl_string,
        "Perl Two int: 37\nPerl Two str: bar\n",
        'Perl stringification should work after modifying attributes',
    );

    cmp-deeply(
        get_events(),
        (),
        'no destructors should have been called yet',
    );
    clear_events;
    $y.DESTROY;
    cmp-deeply(
        get_events(),
        (rx{^Two\.DESTROY},rx{^free_two}),
        'Perl and C destructors should have been called',
    );
    clear_events;
}

done-testing;
