use v6;
use Plackdo::Test::Standalone;
use NativeCall;
sub fork returns Int is native('') { ... }

class Plackdo::Test::Standalone::Linux does Plackdo::Test::Standalone { 
    use Plackdo::Handler::Standalone;
    use Plackdo::LWP::UserAgent;

    method test_p6sgi (Block $app, Block $client) {
        my $pid = fork;
        say $pid;
        if ($pid) {
            say $pid;
            my &cb = sub ($req) {
                return Plackdo::LWP::UserAgent.new.request($req);
            };
            say 'here';
            $client(&cb);
        } else {
            my $handler = Plackdo::Handler::Standalone.new;
            $handler.run($app);
        }
        run("kill $pid");
    }
}

# vim: ft=perl6
