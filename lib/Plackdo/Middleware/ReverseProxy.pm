use v6;
use Plackdo::Middleware;

class Plackdo::Middleware::ReverseProxy does Plackdo::Middleware {

    method call (%env) {

        my $default_port = 80;

        given %env<HTTP_X_FORWARDED_FOR> {
            when m/(<-[,\ ]>+)$/ {
                %env<REMOTE_ADDR> = $/[0].Str;
            }
        }

        given %env<HTTP_X_FORWARDED_HOST> {
            when m/(<-[,\ ]>+)$/ {
                my $host = $/[0].Str;
                %env<SERVER_HOST> = %env<HTTP_HOST> = $host;
            }
        }

        given %env<SERVER_HOST> {
            when m/\:(\d+)$/ {
                %env<SERVER_PORT> = $/[0].Str;
            }
            default {
                %env<SERVER_PORT> = $default_port;
            }
        }
        
        return &!app(%env);
    }
}

# vim: ft=perl6
