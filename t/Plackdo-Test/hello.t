use v6;
use Test;

use Plackdo::Test;

$Plackdo::Test::Impl = 'MockHTTP';

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
        my $req = new_request('GET', 'http://localhost/hello');
        my $res = &cb($req);
        is $res.content, 'Hello, Rakudo';
        is $res.code, 200;
        is $res.header('Content-Type'), 'text/plain';
    }
);

done;

# vim: set ft=perl6 :
