use v6;
use Plackdo::Test::Standalone;
use NativeCall;
sub fork returns Int is native<libc> { ... }

class Plackdo::Test::Standalone::Darwin does Plackdo::Test::Standalone { }

# vim: ft=perl6
