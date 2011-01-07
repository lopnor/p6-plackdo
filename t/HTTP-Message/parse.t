use v6;
use Test;

use Plackdo::HTTP::Message;
use Plackdo::HTTP::Headers;
ok 1;

{
    my $in = "foo: bar\na:b\n\nhoge";
    ok my $m = Plackdo::HTTP::Message.parse($in);
    is $m.WHAT, 'Plackdo::HTTP::Message()';
    is $m.header('foo'), 'bar';
    is $m.header('a'), 'b';
    is $m.content, 'hoge';
}
{
    my $in = q{foo: bar
    baz
hoge: 
 fuga

body
body2
};
    ok my $m = Plackdo::HTTP::Message.parse($in);
    is $m.WHAT, 'Plackdo::HTTP::Message()';
    is $m.header('foo'), "bar\n    baz";
    is $m.header('hoge'), 'fuga';
    is $m.content, "body\nbody2\n";
}
{
    my $req = Plackdo::HTTP::Message.new(
        Plackdo::HTTP::Headers.new(
            Foo => 'bar',
            Hoge => 'foga',
        ),
        'foobarbaz',
    );
    say $req;
    ok my $m = Plackdo::HTTP::Message.parse(~$req);
}
    


done_testing;

# vim: ft=perl6 :
