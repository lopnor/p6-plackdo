use v6;
use Test;
use Plackdo::Test;
use Plackdo::Middleware::AccessLog;

ok 1;

my $logfile = 't/Plackdo-Middleware/log';
my $fh = open($logfile, :w);

my $app = sub (%env) {
    if (%env<REQUEST_METHOD>.lc eq 'get') {
        return [ 200, [ Content-Type => 'text/plain' ], ['Hello, Rakudo']]
    } else {
        return [ 200, [], [] ]
    }
};
$app = Plackdo::Middleware::AccessLog.new( io => $fh ).wrap($app);

test_p6sgi(
    $app,
    sub (&cb) {
        {
            my $req = new_request('GET', '/foo');
            my $res = &cb($req);
            is $res.code, 200;
        }
        {
            my $req = new_request('HEAD', '/foo');
            my $res = &cb($req);
            is $res.code, 200;
        }
    }
);
$fh.close;

ok my $log = slurp $logfile;
ok $log ~~ /'"GET /foo HTTP/1.1" 200 13'/;
ok $log ~~ /'"HEAD /foo HTTP/1.1" 200 -'/;

ok unlink($logfile);

done_testing;

# vim: ft=perl6
