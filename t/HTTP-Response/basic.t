use v6;
use Test;
use Plackdo::HTTP::Response;

ok 1;

{
    my @p6sgi = (
        200,
        [ 
            Content-Length => 13,
            Content-Type => 'text/html',
        ],
        [ '<html></html>' ]
    );
    ok my $res = Plackdo::HTTP::Response.new(@p6sgi);
    is $res.content, '<html></html>';
    is $res.code, 200;
    is $res.header('Content-Length'), 13;
    is $res.header('Content-Type'), 'text/html';
}
{
    my $str = 'HTTP/1.1 200 OK
Content-Length: 13
Content-Type: text/html

<html></html>';
    ok my $res = Plackdo::HTTP::Response.parse($str);
    is $res.content, '<html></html>';
    is $res.code, 200;
    is $res.header('Content-Length'), 13;
    is $res.header('Content-Type'), 'text/html';
}

done_testing;

# vim: ft=perl6 :
