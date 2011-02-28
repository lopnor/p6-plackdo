use v6;
use Test;
use Plackdo::MIME;

ok 1;

sub type($file) { Plackdo::MIME::mime_type($file) }

is type(".gif"), 'image/gif';
is type("foo.png"), "image/png";
is type("foo.GIF"), "image/gif";
ok type("foo.bar") ~~ Mu;
is type("foo.mp3"), "audio/mpeg";

done;

# vim: ft=perl6
