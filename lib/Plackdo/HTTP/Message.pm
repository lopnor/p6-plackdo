use v6;

class Plackdo::HTTP::Message {
    use Plackdo::HTTP::Headers;
    use Plackdo::HTTP::Message::Grammar;
    use Plackdo::HTTP::Message::Actions;

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
        join("\n", $!headers, $!content);
    }

    method parse(Str $in) {
        my $m = Plackdo::HTTP::Message::Grammar.parse(
            $in, actions => Plackdo::HTTP::Message::Actions
        );
        my $headers = Plackdo::HTTP::Headers.new(|$m.ast<headers>.hash);

        return self.new($headers, $m.ast<content>);
    }
}

# vim: ft=perl6 :
