use v6;

role Plackdo::Test::Standalone {
    use Plackdo::Handler::Standalone;
    use Plackdo::LWP::UserAgent;

    method test_p6sgi (Block $app, Block $client) {
        my $port = self.empty_port;
        my $pid = fork;
        if ($pid) {
            my &cb = sub ($req) {
                $req.uri.host = '127.0.0.1';
                $req.uri.port = $port;
                return Plackdo::LWP::UserAgent.new.request($req);
            };
            $client(&cb);
        } else {
            my $handler = Plackdo::Handler::Standalone.new(port => $port);
            $handler.run($app);
        }
        run("kill $pid");
    }

    method empty_port ($port? is copy) {
        $port //= 10000 + 10000.rand.Int;
        while ( $port++ < 20000 ) {
            self.check_port($port) or next;
            return $port;
        }
        die 'empty port not found';
    }

    method check_port ($port) {
        my $sock = Plackdo::Handler::Standalone.make_socket('0.0.0.0', $port);
        if ($sock) {
            $sock.close;
            return 1;
        } else {
            return 0;
        }
    }
}

# vim: ft=perl6
