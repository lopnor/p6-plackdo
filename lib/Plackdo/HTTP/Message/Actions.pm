use v6;

class Plackdo::HTTP::Message::Actions {
    use Plackdo::HTTP::Message;
    use Plackdo::HTTP::Headers;

    method TOP($/) {
        if ($<body>) {
            make Plackdo::HTTP::Message.new(
                $<headers>.ast, 
                $<body>[0].ast
            )
        } else {
            make Plackdo::HTTP::Message.new($<headers>.ast);
        }
    }
    method headers($/) { 
        make Plackdo::HTTP::Headers.new(|$<pair>».ast)
    }
    method pair($/) { make $<key>.ast => $<value>.ast }
    method value($/) { make $/.Str }
    method key($/) { make $/.Str }
    method body($/) { make $/.Str }
}

# vim: ft=perl6 :
