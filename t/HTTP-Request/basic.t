use v6;
use Test;
use Plackdo::HTTP::Request;
ok 1;

{
    ok my $req = Plackdo::HTTP::Request.new(GET => 'http://localhost:5000/foo');
    isa_ok $req, Plackdo::HTTP::Request;
    is $req.request_method, 'GET';
    is $req.uri.WHAT, 'Plackdo::URI()';
    is $req.uri.scheme, 'http';
    is $req.uri.host, 'localhost';
    is $req.uri.port, 5000;
    is $req.uri.path, '/foo';
    ok ! $req.uri.fragment;
    is "$req", "GET /foo HTTP/1.1\nHost: localhost:5000\n\n";
}

done_testing;

# vim: ft=perl6 :
