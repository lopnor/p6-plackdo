use v6;
use Test;

use Plackdo::Request;
use Plackdo::TempBuffer::Memory;

ok 1;

{
    my %env = {REQUEST_URI => 'http://www.example.com/'};
    ok my $req = Plackdo::Request.new(|%env);
    is $req.WHAT, 'Plackdo::Request()';
    is $req.uri, 'http://www.example.com/';
    is $req.uri.path, '/';
}
{
    my $body = 'foo=bar&baz=hoge';
    my %env = {
        REQUEST_URI => 'http://www.example.com/foobar',
        REQUEST_METHOD => 'POST',
        CONTENT_TYPE => 'application/x-www-form-urlencoded',
        CONTENT_LENGTH => $body.bytes,
        'psgi.input' => Plackdo::TempBuffer::Memory.new(buffer => $body),
    };
    ok my $req = Plackdo::Request.new(|%env);
    is $req.param('foo'), 'bar';
    is $req.parameters.perl, q!{"foo" => "bar", "baz" => "hoge"}!;
}

done_testing;

# vim: ft=perl6 :
