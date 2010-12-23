use v6;

class Plackdo::HTTP::Message::Actions {

    method TOP($/) {
        make {
            headers => $<headers>.ast,
            $<content> ?? content => $<content>[0].ast !! (),
        };
    }
    method headers($/) { 
        make Array.new($<pair>».ast);
    }
    method pair($/) { make $<key>.ast => $<value>.ast }
    method value($/) { make $/.Str }
    method key($/) { make $/.Str }
    method content($/) { make $/.Str }
}

# vim: ft=perl6 :
