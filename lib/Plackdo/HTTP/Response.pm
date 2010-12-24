use v6;
use Plackdo::HTTP::Message;

grammar Plackdo::HTTP::Response::Grammar is Plackdo::HTTP::Message::Grammar {
    regex TOP { ^ <status_line> <crlf> <headers> [ <crlf> ** 2 <content> ]? $ }
    regex status_line { [<protocol> ' ']? <code> ' ' <message> }
    token protocol { \S+ }
    token code { \d**3 }
    token message { \S+ }
}

class Plackdo::HTTP::Response::Actions is Plackdo::HTTP::Message::Actions {
    method TOP($/) {
        make {
            status_line => {
                protocol => $<status_line><protocol>[0].Str, 
                code => $<status_line><code>.Str, 
                message => $<status_line><message>.Str
            },
            headers => $<headers>.ast,
            $<content> ?? content => $<content>[0].Str !! (),
        };
    }
}

class Plackdo::HTTP::Response is Plackdo::HTTP::Message {

    has Int $.code;

    multi method new (@in) {
        self.bless(
            *,
            code => @in[0],
            headers => Plackdo::HTTP::Headers.new(|(@in[1].hash)),
            content => [~]@in[2],
        );
    }

    method parse (Str $in) {
        my $m = Plackdo::HTTP::Response::Grammar.parse(
            $in, actions => Plackdo::HTTP::Response::Actions
        );
        return self.new([
            $m.ast<status_line><code>, 
            $m.ast<headers>,
            $m.ast<content>
        ]);
    }
}

# vim: ft=perl6 :
