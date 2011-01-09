use v6;
use Plackdo::Test::Standalone;
use NativeCall;
sub fork returns Int is native('') { ... }

class Plackdo::Test::Standalone::Linux does Plackdo::Test::Standalone { }

# vim: ft=perl6
