use v6;

use NativeCall;
sub fork returns Int is native('') { ... }

class Plackdo::Test::Standalone::Linux is Plackdo::Test::Standalone { }

# vim: ft=perl6
