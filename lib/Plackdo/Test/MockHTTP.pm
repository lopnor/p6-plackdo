use v6;

class Plackdo::Test::MockHTTP {
    use Plackdo::HTTP::Response;

    method test_p6sgi (Block $app, Block $client) {
        my &cb = sub ($req) {
            my %env = $req.to_p6sgi;
            my $res = $app(%env);
            return Plackdo::HTTP::Response.new($res);
        };
        $client(&cb);
    }
}

# vim: set ft=perl6 :
