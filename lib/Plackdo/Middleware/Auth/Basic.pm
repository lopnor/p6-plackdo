use v6;
use Plackdo::Middleware;

class Plackdo::Middleware::Auth::Basic does Plackdo::Middleware {
    use MIME::Base64;
    has $!realm = 'restricted area';
    has &!authenticator;

    method call (%env) {
        my $auth = %env<HTTP_AUTHORIZATION> or return self.unauthorized;
        
        if $auth ~~ m/^ Basic ' ' (.*) $/ {
            my ($user, $pass) = try {
                MIME::Base64.decode_base64($/[0].Str).split(':');
            };
            if (&!authenticator($user, $pass, %env)) {
                %env<REMOTE_USER> = $user;
                return &!app(%env);
            }
        }
        return self.unauthorized;
    }

    method unauthorized {
        my $body = 'Authorization required';

        return [
            401,
            [
                Content-Type => 'text/plain',
                Content-Length => $body.bytes,
                WWW-Authenticate => 'Basic realm="' ~ $!realm ~ '"',
            ],
            [ $body ]
        ];
    }
}

# vim: ft=perl6 :
