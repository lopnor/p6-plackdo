use v6;
use Test;
use Plackdo::Test;
use Plackdo::LWP::UserAgent;

ok 1;

$Plackdo::Test::Impl = 'Standalone';

test_p6sgi(
    sub (%env) {
        my $res = %env<REQUEST_METHOD>;
        return [
            200, 
            [ 
                Content-Type => 'text/plain',
                Content-Length => $res.bytes,
            ],
            [ $res ]
        ];
    },
    sub (&cb) {
        {
            my $req = Plackdo::HTTP::Request.new('GET', 'http://localhost:5000/');
            my $res  = &cb($req);
#            my $ua = Plackdo::LWP::UserAgent.new;
#            my $res = $ua.request($req);
            is $res.WHAT, 'Plackdo::HTTP::Response()';
            is $res.content, 'GET';
            is $res.code, 200;
            is $res.header('Content-Type'), 'text/plain';
            is $res.header('Content-Length'), $res.content.bytes;
        }
        {
            my $req = Plackdo::HTTP::Request.new(
                POST => 'http://localhost:5000/',
                headers => {Content-Type => 'application/x-www-form-urlencoded'},
                content => 'foo=bar',
            );
            my $res = &cb($req);
#            my $ua = Plackdo::LWP::UserAgent.new;
#            my $res = $ua.request($req);
            is $res.WHAT, 'Plackdo::HTTP::Response()';
            is $res.content, 'POST';
            is $res.code, 200;
            is $res.header('Content-Type'), 'text/plain';
            is $res.header('Content-Length'), $res.content.bytes;
        }
    }
);

done_testing;

# vim: ft=perl6 :
