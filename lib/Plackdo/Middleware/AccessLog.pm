use v6;
use Plackdo::Middleware;

class Plackdo::Middleware::AccessLog does Plackdo::Middleware {

    method call (%env) {
        my $res = &!app(%env);
        say join(' ', 
            '[' ~ DateTime.now ~ ']', 
            %env<REQUEST_URI>, 
            $res[0],
            $res[2][0].bytes,
        );
        return $res;
    }
}

# vim: ft=perl6 :
