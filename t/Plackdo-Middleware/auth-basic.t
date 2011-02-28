use v6;
use Test;
use Plackdo::Test;
use Plackdo::Middleware::Auth::Basic;
use Plackdo::HTTP::Request;
use MIME::Base64;

ok 1;

my $app = sub (%env) { [200, [Content-Type => 'text/plain'], ['ok']] };
$app = Plackdo::Middleware::Auth::Basic.new(
    authenticator => sub ($user, $pass, %env) {
        return $user eq $pass;
    }
).wrap($app);

test_p6sgi(
    $app,
    sub (&cb) {
        {
            my $req = Plackdo::HTTP::Request.new(GET => '/');
            ok my $res = &cb($req);
            is $res.code, 401;
            is $res.header('WWW-Authenticate'), 'Basic realm="restricted area"';
        }
        {
            my $req = Plackdo::HTTP::Request.new(
                GET => '/',
                headers => {
                    Authorization => 'Basic ' ~ MIME::Base64.encode_base64('foo:bar'),
                }
            );
            ok my $res = &cb($req);
            is $res.code, 401;
            is $res.header('WWW-Authenticate'), 'Basic realm="restricted area"';
        }
        {
            my $req = Plackdo::HTTP::Request.new(
                GET => '/',
                headers => {
                    Authorization => 'Basic hoge'
                }
            );
            ok my $res = &cb($req);
            is $res.code, 401;
            is $res.header('WWW-Authenticate'), 'Basic realm="restricted area"';
        }
        {
            my $req = Plackdo::HTTP::Request.new(
                GET => '/',
                headers => {
                    Authorization => 'Basic ' ~ MIME::Base64.encode_base64('foo:foo'),
                }
            );
            ok my $res = &cb($req);
            is $res.code, 200;
            is $res.content, 'ok';
        }
    }
);

done;

# vim: ft=perl6 :
