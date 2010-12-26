use v6;
use Plackdo::Middleware;

class Plackdo::Middleware::XFramework does Plackdo::Middleware {
    use Plackdo::Util;

    has $.framework;

    method call (%env) {
        my $res = &!app(%env);
        self.response_cb($res, sub ($in) {
            if ($.framework) {
                Plackdo::Util::header_set($in[1], 
                    'X-Framework', $.framework
                );
            }
            return $in;
        });
        return $res;
    }
}

# vim: ft=perl6 :
