use v6;

grammar Plackdo::HTTP::Message::Grammar {
    regex TOP { <headers> [ <crlf> ** 2 <content> ]? }
    regex headers { <pair> ** <crlf> }
    regex pair { <key> ':'\s* <value> }
    regex value { <value_line> ** [ <crlf> [\t|' ']+ ] }
    regex value_line { [ \S | ' ' ]+ }
    regex crlf { \r?\n }
    regex key  { \S+ }
    token content { .+ }
}

class Plackdo::HTTP::Message::Actions {
    method TOP($/) {
        make {
            headers => $<headers>.ast,
            $<content> ?? content => $<content>[0].Str !! (),
        };
    }
    method headers($/) { 
        make Array.new($<pair>».ast);
    }
    method pair($/) { make $<key>.Str => $<value>.Str }
}

class Plackdo::HTTP::Message {
    use Plackdo::HTTP::Headers;

    has Plackdo::HTTP::Headers $!headers;
    has Str $.content;

    multi method new (Plackdo::HTTP::Headers $in, Str $content?) {
        self.bless(
            *,
            :headers($in),
            :content($content)
        );
    }

    multi method header (Str $name) {
        return $!headers.header($name);
    }

    multi method header (*%in) {
        $!headers.header(|%in);
    }

    method Str() {
        join("\n", 
            $!headers // '', 
            $!content // '' 
        );
    }

    method parse(Str $in) {
        my $m = Plackdo::HTTP::Message::Grammar.parse(
            $in, actions => Plackdo::HTTP::Message::Actions
        );
        $m or return;
        my $headers = Plackdo::HTTP::Headers.new(|$m.ast<headers>.hash);

        return self.new($headers, $m.ast<content>);
    }
}

# vim: ft=perl6 :
