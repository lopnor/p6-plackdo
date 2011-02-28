use v6;
use Test;
use Plackdo::MIME;

ok( Plackdo::MIME::mime_type(".vcd") ~~ Mu );

Plackdo::MIME::set_fallback(
    sub ($ext) { 
        return {".vcd" => "application/x-cdlink"}{$ext};
    }
);
is Plackdo::MIME::mime_type(".vcd"), "application/x-cdlink";

done;

# vim: ft=perl6 :
