use v6;
use Test;

use Plackdo::Test;

$Plackdo::Test::Impl = 'Standalone';

test_p6sgi(
    sub (%env) {
        return [
            200, 
            [ 
                Content-Type => 'text/plain',
                Content-Length => 13,
            ],
            [ 'Hello, Rakudo' ]
        ];
    },
    sub (&cb) {
        my $req = new_request('GET', 'http://127.0.0.1:5000/hello');
        my $res = &cb($req);
        is $res.content, 'Hello, Rakudo';
        is $res.code, 200;
        is $res.header('Content-Type'), 'text/plain';
    }
);

done_testing;

# vim: set ft=perl6 :
