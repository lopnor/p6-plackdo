use v6;
use Test;
use Plackdo::Test;
use Plackdo::Middleware::Static;

ok 1;

my $app = sub (%env) {
    return [ 200, [ Content-Type => 'text/plain' ], ['Hello, Rakudo']]
};
$app = Plackdo::Middleware::Static.new(
    root => 't/Plackdo-Middleware',
    path => rx{^'/static/'},
).wrap($app);

test_p6sgi(
    $app,
    sub (&cb) {
        {
            my $req = new_request('GET', '/static/../foo.jpg');
            my $res = &cb($req);
            is $res.code, 403;
        }
        {
            my $req = new_request('GET', '/static/foo.jpg');
            my $res = &cb($req);
            is $res.code, 404;
        }
        {
            my $file = 't/Plackdo-Middleware/static/lopnor.png';
            my $req = new_request('GET', '/static/lopnor.png');
            my $res = &cb($req);
            is $res.code, 200; 
            is $res.header('Content-Type'), 'image/png';
            is $res.header('Content-Length'), $file.IO.stat.size;
            is $res.content.bytes, $file.IO.stat.size;
        }
    }
);

done_testing;

# vim: ft=perl6 :
