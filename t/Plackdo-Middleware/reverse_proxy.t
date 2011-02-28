use v6;
use Test;
use Plackdo::Test;
use Plackdo::HTTP::Request;
use Plackdo::Middleware::ReverseProxy;

ok 1;

my $app = sub (%env) {
    return [ 200, [ Content-Type => 'text/plain' ], [%env.perl]]
};
$app = Plackdo::Middleware::ReverseProxy.new.wrap($app);

test_p6sgi(
    $app,
    sub (&cb) {
        my $req = Plackdo::HTTP::Request.new( 
            GET => 'http://localhost:5000/foo',
            headers => {
                X-Forwarded-For => '192.168.0.1',
                X-Forwarded-Host => 'foobar.proxy.example.com',
            },
        );
        my $res = &cb($req);
        ok $res;
        my %env = $res.content.eval;
        is %env<HTTP_HOST>, 'foobar.proxy.example.com';
        is %env<SERVER_PORT>, 80;
    }
);

done;

# vim: ft=perl6 :
