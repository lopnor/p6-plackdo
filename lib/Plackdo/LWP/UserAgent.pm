use v6;

class Plackdo::LWP::UserAgent {
    use Plackdo::Util;
    use Plackdo::HTTP::Request;
    use Plackdo::HTTP::Response;

    method request (Plackdo::HTTP::Request $req) {
        return self!send_request($req);
    }

    method !send_request (Plackdo::HTTP::Request $req) {
        my $scheme = $req.uri.scheme;
        my $instance = load_instance($scheme, "Plackdo::LWP::Protocol")
            or return fail;
        my $res = $instance.request($req);
        
        return $res;
    }
}

# vim: ft=perl6
