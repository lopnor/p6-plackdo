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
{
    ok my $req = Plackdo::HTTP::Request.new(
        POST => 'http://www.example.com/foo?bar=baz',
        headers => {
            Content-Type => 'application/x-www-form-urlencoded'
        },
        content => 'foo=bar&hoge=fuga'
    );
    isa_ok $req, Plackdo::HTTP::Request;
    is $req.request_method, 'POST';
    is $req.uri.WHAT, 'Plackdo::URI()';
    is $req.uri, 'http://www.example.com/foo?bar=baz';
    is $req.headers, "Host: www.example.com\nContent-Type: application/x-www-form-urlencoded\n";
    is $req.content, 'foo=bar&hoge=fuga';
    is $req, "POST /foo?bar=baz HTTP/1.1
Host: www.example.com
Content-Length: 17
Content-Type: application/x-www-form-urlencoded

foo=bar&hoge=fuga";
}

done_testing;

# vim: ft=perl6 :
