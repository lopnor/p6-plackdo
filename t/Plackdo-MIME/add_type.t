use v6;
use Test;
use Plackdo::MIME;

Plackdo::MIME::add_type(".foo" => "text/foo");
is( Plackdo::MIME::mime_type("bar.foo"), "text/foo" );

Plackdo::MIME::add_type(".c" => "application/c-source");
is( Plackdo::MIME::mime_type("FOO.C"), "application/c-source" );

done;

# vim: ft=perl6 :
