use v6;

class Plackdo::Test::Standalone {
    use Plackdo::Handler::Standalone;
    use NativeCall;
    use Plackdo::LWP::UserAgent;

    method !fork returns Int is native<libc> { ... }

    method test_p6sgi (Block $app, Block &client) {
        my $pid;
        if ($pid = fork) {
            my &cb = sub ($req) {
                return Plackdo::LWP::UserAgent.new.request($req);
            };
            &client(&cb);
        } else {
            my $handler = Plackdo::Handler::Standalone.new;
            $handler.run($app);
        }
        run("kill $pid");
    }
}

# vim: ft=perl6
