use v6;
use Test;
use Plackdo::Handler::Standalone;

ok 1;

my $handler = Plackdo::Handler::Standalone.new;
my %env;
is $handler.parse_request('', %env), -2;

done_testing;
# vim: ft=perl6 :
