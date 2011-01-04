use v6;
use Plackdo::Middleware;

class Plackdo::Middleware::Runtime does Plackdo::Middleware {
    use Plackdo::Util;

    method call (%env) {
        my $start = now;
        my $res = &!app(%env);
        self.response_cb($res, sub ($in) {
            my $req_time = now - $start;
            Plackdo::Util::header_set($in[1], 'X-Runtime', $req_time.Str);
            return $in;
        });
        return $res;
    }
}

# vim: ft=perl6
