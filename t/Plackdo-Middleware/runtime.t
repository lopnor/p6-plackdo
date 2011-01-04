use v6;
use Test;

use Plackdo::Test;
use Plackdo::Middleware::Runtime;

ok 1;

my $app = sub (%env) {
    return [200, [Content-Type => 'text/plain'], ['ok']]
};

ok( $app = Plackdo::Middleware::Runtime.new.wrap($app) );

test_p6sgi(
    $app,
    sub (&cb) {
        my $req = new_request('GET', '/');
        my $res = &cb($req);
        ok( my $t = $res.header('X-Runtime') );
        ok $t ~~ /^ <[0..9 \.]>+ $/;
    }
);

done_testing;

# vim: ft=perl6 :
