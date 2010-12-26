use v6;
use Plackdo::HTTP::Message;

class Plackdo::HTTP::Request is Plackdo::HTTP::Message {
    use Plackdo::URI;

    has Str $.request_method;
    has Plackdo::URI $.uri;

    multi method new (*%in) {
        my $headers_in = %in.delete(<headers>);
        my $content = %in.delete(<content>);
        my $in = %in.pairs[0];
        my $uri = Plackdo::URI.new($in.value);
        my $headers = Plackdo::HTTP::Headers.new(
            Host => $uri.host_port(),
        );
        if ($headers_in) {
            $headers.header(|$headers_in);
        }
        self.bless(
            *,
            request_method => $in.key,
            uri => $uri,
            headers => $headers,
            content => $content,
        );
    }

    multi method new (Str $method, Str $uri) {
        self.bless(
            *,
            request_method => $method,
            uri => Plackdo::URI.new($uri),
        );
    }

    method to_p6sgi {
        my %env = {
            REQUEST_METHOD => $!request_method,
            SCRIPT_NAME => '',
            PATH_INFO => $!uri.path,
            SERVER_PORT => $!uri.port,
            SERVER_ADDR => $!uri.host,
            SERVER_PROTOCOL => 'HTTP/1.1',
            REQUEST_URI => $!uri.Str,
            QUERY_STRING => $!uri.query,
        };
        for $.headers.pairs -> $p {
            my $key = $p.key.uc.subst('-', '_', :g);
            unless ( $key eq any <CONTENT_TYPE CONTENT_LENGTH> ) {
                $key = 'HTTP_'~$key
            }
            %env{$key} = $p.value;
        }
        return %env;
    }

    method the_request {
        join(' ', 
            $.request_method, 
            ( $.uri.path // '/' ) ~ ($.uri.query ?? '?' ~ $.uri.query !! ''),
            'HTTP/1.1'
        );
    }

    method Str() {
        if ($.content) { self.header(Content-Length => $.content.bytes) }
        join("\n", self.the_request, self.Plackdo::HTTP::Message::Str());
    }
}

# vim: ft=perl6 :
