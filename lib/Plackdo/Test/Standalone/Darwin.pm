use v6;
use Plackdo::Test::Standalone;
use NativeCall;
sub fork returns Int is native<libc> { ... }

class Plackdo::Test::Standalone::Darwin does Plackdo::Test::Standalone { 
    use Plackdo::Handler::Standalone;
    use Plackdo::LWP::UserAgent;

    method test_p6sgi (Block $app, Block $client) {
        my $pid = fork;
        if ($pid) {
            my &cb = sub ($req) {
                return Plackdo::LWP::UserAgent.new.request($req);
            };
            $client(&cb);
        } else {
            my $handler = Plackdo::Handler::Standalone.new;
            $handler.run($app);
        }
        run("kill $pid");
    }
}

# vim: ft=perl6
