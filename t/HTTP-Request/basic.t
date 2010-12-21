use v6;
use Test;
use Plackdo::HTTP::Request;
ok 1;

{
    ok my $req = Plackdo::HTTP::Request.new(GET => 'http://localhost:5000/foo');
    isa_ok $req, Plackdo::HTTP::Request;
}

done_testing;

# vim: ft=perl6 :
