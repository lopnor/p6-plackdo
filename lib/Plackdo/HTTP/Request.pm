use v6;
use Plackdo::HTTP::Message;

class Plackdo::HTTP::Request is Plackdo::HTTP::Message {
    use Plackdo::URI;

    has Str $!request_method;
    has Plackdo::URI $!uri;

    multi method new (Str $method, Str $uri) {
        self.bless(
            *,
            request_method => $method,
            uri => Plackdo::URI.new($uri),
        );
    }

    method to_p6sgi {
        return {
            REQUEST_METHOD => $!request_method,
            SCRIPT_NAME => '',
            PATH_INFO => $!uri.path,
            SERVER_PORT => $!uri.port,
            SERVER_ADDR => $!uri.host,
            SERVER_PROTOCOL => $!uri.scheme,
            REQUEST_URI => $!uri.Str,
            QUERY_STRING => $!uri.query,
        };
    }
}

# vim: ft=perl6 :
