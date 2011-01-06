use v6;
use Test;
use Plackdo::Test;
use Plackdo::Middleware::Conditional;
use Plackdo::Middleware::XFramework;
use Plackdo::HTTP::Request;

ok 1;

my $app = sub (%env) { return [200, [Content-Type => 'text/plain'], ['Hello']] };

$app = Plackdo::Middleware::Conditional.new(
    middleware => Plackdo::Middleware::XFramework.new(framework => 'Testing'),
    condition => sub (%env) {%env<HTTP_X_FOO>//'' ~~ m/:i Bar/}
).wrap($app);

test_p6sgi(
    $app,
    sub (&cb) {
        {
            my $req = Plackdo::HTTP::Request.new( GET => '/' );
            my $res = &cb($req);
            is $res.content, 'Hello';
        }
        {
            my $req = Plackdo::HTTP::Request.new(
                GET => '/',
                headers => { X-Foo => 'bar' }
            );
            my $res = &cb($req);
            is $res.header('X-Framework'), 'Testing';
        }
    }
);

done_testing;

# vim: ft=perl6
