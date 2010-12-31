use v6;
use Test;
use Plackdo::Test;
use Plackdo::Builder;
use Plackdo::Middleware::XFramework;

ok 1;

ok my $app = sub (%env) {
    return [ 200, [ Content-Type => 'text/plain' ], ['Hello, Rakudo']]
};

ok my $builder = Plackdo::Builder.new;
ok $builder.add_middleware(
    Plackdo::Middleware::XFramework.new(framework => 'Plackdo::Builder')
);
ok $app = $builder.to_app($app);

test_p6sgi(
    $app, 
    sub (&cb) {
        my $req = new_request('GET', '/foo');
        my $res = &cb($req);
        is $res.header('X-Framework'), 'Plackdo::Builder';
        ok $res.content, 'Hello, Rakudo';
    }
);

done_testing;

# vim: ft=perl6 :
