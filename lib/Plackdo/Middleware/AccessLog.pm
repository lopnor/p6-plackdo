use v6;
use Plackdo::Middleware;

class Plackdo::Middleware::AccessLog does Plackdo::Middleware {

    has $!io = $*ERR;

    method call (%env) {
        my $res = &!app(%env);
        $!io.say( 
            sprintf('[%s] "%s %s %s" %d %d',
                DateTime.now,
                %env<REQUEST_METHOD>, 
                %env<REQUEST_URI>, 
                %env<SERVER_PROTOCOL>, 
                $res[0],
                $res[2][0].bytes,
            )
        );
        return $res;
    }
}

# vim: ft=perl6 :
