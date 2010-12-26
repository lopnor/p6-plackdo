use v6;
use Test;
use Plackdo::Util;

ok 1;

{
    my $headers = ['foo' => 'bar', 'hoge' => 'fuga'];
    is Plackdo::Util::header_get($headers, 'FOO'), 'bar';
}
{
    my $headers = ['foo' => 'bar', 'hoge' => 'fuga', 'FOO' => 'baz'];
    ok my $str = Plackdo::Util::header_get($headers, 'FOO');
    is $str, 'bar';
}
{
    my $headers = ['foo' => 'bar', 'hoge' => 'fuga', 'FOO' => 'baz'];
    ok (my @ret = Plackdo::Util::header_get($headers, 'FOO'));
    is @ret[0], 'bar';
    is @ret[1], 'baz';
}
{
    my $headers = ['foo' => 'bar', 'hoge' => 'fuga'];
    Plackdo::Util::header_set($headers, 'foo', 'baz');
    is Plackdo::Util::header_get($headers, 'foo'), 'baz';
}

done_testing;

# vim: ft=perl6 :
