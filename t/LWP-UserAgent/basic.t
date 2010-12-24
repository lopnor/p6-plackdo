use v6;
use Test;
use NativeCall;
use Plackdo::LWP::UserAgent;
use Plackdo::Handler::Standalone;

ok 1;

sub fork returns Int is native<libc> { ... }

my $pid;
$pid = fork();
if ($pid) {
    my $req = Plackdo::HTTP::Request.new('GET', 'http://localhost:5000/');
    my $ua = Plackdo::LWP::UserAgent.new;
    my $res = $ua.request($req);
    is $res.WHAT, 'Plackdo::HTTP::Response()';
    is $res.content, 'Hello, Rakudo';
    is $res.code, 200;
    is $res.header('Content-Type'), 'text/plain';
    is $res.header('Content-Length'), 13;
} else {
    my $handler = Plackdo::Handler::Standalone.new;
    $handler.run( sub (%env) {
        return [
            200, 
            [ 
                Content-Type => 'text/plain',
                Content-Length => 13,
            ],
            [ 'Hello, Rakudo' ]
        ];
    });
}
run("kill $pid");

done_testing;

# vim: ft=perl6 :
