use v6;

class Plackdo::LWP::UserAgent {
    use Plackdo::HTTP::Request;
    use Plackdo::HTTP::Response;

    method request(Plackdo::HTTP::Request $req) {
        return Plackdo::HTTP::Response.new;
    }
}

# vim: ft=perl6
