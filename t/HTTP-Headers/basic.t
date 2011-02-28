use v6;
use Test;
use Plackdo::HTTP::Headers;

{
    ok my $headers = Plackdo::HTTP::Headers.new;
    ok ! $headers.header('foo');
}
{
    ok my $headers = Plackdo::HTTP::Headers.new;
    ok $headers.header(foo => 'bar');
    is $headers.header('foo'), 'bar';
}
{
    ok my $headers = Plackdo::HTTP::Headers.new;
    my %in = foo => 'bar';
    ok $headers.header(|%in);
    is $headers.header('foo'), 'bar';
}
{
    ok my $headers = Plackdo::HTTP::Headers.new(
        Content-Type => 'text/html',
        Content-Length => 10,
    );
    is $headers.header('Content-Type'), 'text/html';
    ok $headers.header( 
        Content-Type => 'text/xml',
        User-Agent   => 'libwww-perl',
    );
    is $headers.header('Content-Type'), 'text/xml';
    is $headers.header('User-Agent'), 'libwww-perl';
    is $headers.header('Content-Length'), 10;
    is "{$headers}", join("\n",
        'User-Agent: libwww-perl',
        'Content-Length: 10',
        'Content-Type: text/xml',
        ''
    );
}

done;

# vim: ft=perl6 :
