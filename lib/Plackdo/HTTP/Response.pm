use v6;
use Plackdo::HTTP::Message;

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
}

# vim: ft=perl6 :
