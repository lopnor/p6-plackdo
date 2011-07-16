use v6;

use Test;
plan 10;

use Plackdo::Test;
use Plackdo::App::URLMap;

ok 1, 'Can load module';

my Plackdo::App::URLMap $urlmap .= new;
ok $urlmap, 'Can create URLMap instance';

$urlmap.mount('http://example.com/foo', sub (%env) { return [ 200, [ Content-Type => 'text/plain' ], [ "PATH_INFO %env<PATH_INFO>" ] ] });

$urlmap.mount('http://example.com/bar', sub (%env) { return [ 200, [ Content-Type => 'text/plain' ], [ "PATH_INFO %env<PATH_INFO> (with host)" ] ] });

$urlmap.mount('/bar', sub (%env) { return [ 200, [ Content-Type => 'text/plain' ], [ "PATH_INFO %env<PATH_INFO>" ] ] });

$urlmap.mount('/barbaz', sub (%env) { return [ 200, [ Content-Type => 'text/plain' ], [ "barbaz!" ] ] });

test_p6sgi(
    $urlmap.to_app, 
    sub (&cb) {
        my $res;

        $res = &cb(new_request('GET', 'http://example.com/foo/testing'));
        is $res.content, 'PATH_INFO /testing', 'Matches host + path';

        $res = &cb(new_request('GET', 'http://perl6.org/foo/testing'));
        is $res.code, 404, 'Refuses to match a different hostname';

        $res = &cb(new_request('GET', 'http://nomatch.example.com/foo/testing'));
        is $res.code, 404, 'Refuses to match a subdomain';

        $res = &cb(new_request('GET', 'http://perl6.org/bar/testing'));
        is $res.content, 'PATH_INFO /testing', 'Matches path and Any host';

        $res = &cb(new_request('GET', 'https://example.com/bar/testing'));
        is $res.content, 'PATH_INFO /testing (with host)', 'Matches path and explicit host';

        $res = &cb(new_request('GET', '/bar/testing'));
        is $res.content, 'PATH_INFO /testing', 'Matches path only';

        $res = &cb(new_request('GET', '/bar'));
        is $res.content, 'PATH_INFO ', 'Empty PATH_INFO when no trailing slash';

        $res = &cb(new_request('GET', '/barbaz'));
        is $res.content, 'barbaz!', 'Longest path wins';
    }
);

done;

# vim: ft=perl6 :
