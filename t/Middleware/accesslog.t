use v6;
use Test;
use Plackdo::Test;
use Plackdo::Middleware::AccessLog;

ok 1;

my $logfile = 't/Middleware/log';
my $fh = open($logfile, :w);

my $app = sub (%env) {
    return [ 200, [ Content-Type => 'text/plain' ], ['Hello, Rakudo']]
};
$app = Plackdo::Middleware::AccessLog.new( io => $fh ).wrap($app);

test_p6sgi(
    $app,
    sub (&cb) {
        my $req = new_request('GET', '/foo');
        my $res = &cb($req);
        is $res.code, 200;
    }
);
$fh.close;

ok my $log = slurp $logfile;
ok $log ~~ /"GET\ \/foo\ HTTP\/1.1"/;

ok unlink($logfile);

done_testing;

# vim: ft=perl6
