use v6;
use Test;
use Plackdo::URI;
ok 1;

{
    ok my $uri = Plackdo::URI.new('http://localhost/foobar?fuga#hoge');
    isa_ok $uri, Plackdo::URI;
    is $uri.scheme, 'http';
    is $uri.host, 'localhost';
    is $uri.port, 80;
    is $uri.path, '/foobar';
    is $uri.query, 'fuga';
    is $uri.fragment, 'hoge';
    is $uri, 'http://localhost/foobar?fuga#hoge'
}
{
    ok my $uri = Plackdo::URI.new('https://localhost/foobar?fuga#hoge');
    isa_ok $uri, Plackdo::URI;
    is $uri.scheme, 'https';
    is $uri.host, 'localhost';
    is $uri.port, 443;
    is $uri.path, '/foobar';
    is $uri.query, 'fuga';
    is $uri.fragment, 'hoge';
    is $uri, 'https://localhost/foobar?fuga#hoge'
}
{
    ok my $uri = Plackdo::URI.new('https://localhost:8443/foobar?fuga#hoge');
    isa_ok $uri, Plackdo::URI;
    is $uri.scheme, 'https';
    is $uri.host, 'localhost';
    is $uri.port, 8443;
    is $uri.path, '/foobar';
    is $uri.query, 'fuga';
    is $uri.fragment, 'hoge';
    is $uri, 'https://localhost:8443/foobar?fuga#hoge'
}
{
    ok my $uri = Plackdo::URI.new(
        scheme => 'https',
        host => 'localhost',
        path => '/hoge'
    );
    is $uri.scheme, 'https';
    is $uri.host, 'localhost';
    is $uri.port, 443;
    is $uri.path, '/hoge';
    is $uri, 'https://localhost/hoge';
}
{
    ok my $uri = Plackdo::URI.new(
        scheme => 'http',
        host => 'localhost',
        path => '/hoge'
    );
    is $uri.scheme, 'http';
    is $uri.host, 'localhost';
    is $uri.port, 80;
    is $uri.path, '/hoge';
    is $uri, 'http://localhost/hoge';
}
{
    ok my $uri = Plackdo::URI.new(
        scheme => 'http',
        host => 'localhost',
        port => 8080,
        path => '/'
    );
    is $uri.scheme, 'http';
    is $uri.host, 'localhost';
    is $uri.port, 8080;
    is $uri.path, '/';
    is $uri, 'http://localhost:8080/';
}

{
    ok my $uri = Plackdo::URI.new;
    isa_ok $uri, Plackdo::URI;
    $uri.scheme = 'http';
    $uri.host = 'localhost';
    $uri.port = 8080;
    $uri.path = '/';
    is ~$uri, "http://localhost:8080/";
}

done_testing;

# vim: ft=perl6 :
