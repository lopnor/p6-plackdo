use v6;

use NativeCall;
sub fork returns Int is native<libc> { ... }

class Plackdo::Test::Standalone::Darwin is Plackdo::Test::Standalone { }

# vim: ft=perl6
