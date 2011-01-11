use v6;
use Plackdo::Handler;

sub PF_INET {2}
sub SOCK_STREAM {1}
sub TCP {6}

class Plackdo::Handler::Standalone does Plackdo::Handler {
    use Plackdo::HTTP::Status;
    use Plackdo::HTTP::Request;
    use Plackdo::TempBuffer::Memory;

    has Str $.host is rw = '0.0.0.0';
    has Int $.port is rw = 5000;
    has &.server_ready = sub {};
    has $!listen_sock;

    method set_attr (*%args) {
        for %args.pairs {
            my $value = .value;
            given .key {
                when 'host' {$.host = $value}
                when 'port' {$.port = $value}
            }
        }
    }

    method run (&app) {
        self.setup_listener;
        self.accept_loop(&app);
    }

    method setup_listener {
        my $sock = self.make_socket( $.host, $.port );
        unless ($sock) {
            die "could not bind to {$.host}:{$.port}";
        }
        $sock.listen();
        $!listen_sock = $sock;
        &.server_ready();
    }

    method make_socket ($host, $port) {
        my $sock = IO::Socket::INET.socket( PF_INET, SOCK_STREAM, TCP );

        # IO::Socket::INET.bind doesn't return result 
        my $attr = $sock.^attributes(:local).grep({ .name eq '$!PIO'})[0];
        my $pio = $attr.get_value($sock);
        my $sockaddr = $pio.sockaddr( $host, $port );
        my $result = $pio.bind($sockaddr);
#        $sock.bind( $.host, $.port );
        if ($result == 0) {
            return $sock;
        }
        return;
    }

    method accept_loop (&app) { 
        while my $conn = $!listen_sock.accept() {
            my %env;
            my $res;
            my $buf;
            my $tmpfile;
            while 1 {
                $buf ~= $conn.recv or last;
                my $reqlen = self.parse_request($buf, %env);
                if ($reqlen >= 0) {
                    $buf = $buf.substr($reqlen);
                    if (my $cl = %env<CONTENT_LENGTH>) {
                        my $tmpfile = Plackdo::TempBuffer::Memory.new;
                        while $cl > 0 {
                            my $chunk;
                            if ($buf.chars) {
                                $chunk = $buf;
                                $buf = '';
                            } else {
                                $chunk = $conn.recv;
                            }
                            $tmpfile.print($chunk);
                            $cl -= $chunk.chars;
                        }
                        %env<psgi.input> = $tmpfile.rewind;
                    }
                    $res = self.make_response(&app(%env));
                    last;
                }
            }
            $conn.send($res);
            $conn.close;
            $tmpfile.unlink if $tmpfile;
        }
    }

    method parse_request ($chunk, %env) {
        my $m = Plackdo::HTTP::Request::Grammar.parse(
            $chunk, actions => Plackdo::HTTP::Request::Actions
        );
        $m or return -2;
        my $uri = Plackdo::URI.new($m.ast<uri>);

        %env<SCRIPT_NAME> = '';
        %env<PATH_INFO> = $uri.path;
        %env<SERVER_PORT> = $.port;
        %env<SERVER_ADDR> = $.host;
        %env<SERVER_PROTOCOL> = $m<the_request><protocol>.Str;
        %env<REQUEST_METHOD> = $m.ast<method>;
        %env<REQUEST_URI> = ~$uri;
        %env<QUERY_STRING> = $uri.query;

        for $m.ast<headers>.hash -> $p {
            my $key = $p.key.uc.subst('-', '_', :g);
            if ( $key !~~ any <CONTENT_TYPE CONTENT_LENGTH> ) {
                $key = 'HTTP_'~$key
            }
            %env{$key} = $p.value;
        }
        return $m<eoh>.to;
    }

    method make_response (@args) {
        my $status = @args[0];
        my $headers;
        for @args[1].hash {
            $headers ~= join(": ", .key, .value) ~ "\r\n";
        }

        return join("\r\n",
            join(' ', 
                "HTTP/1.0", 
                $status, 
                Plackdo::HTTP::Status.status_message($status)
            ),
            $headers,
            [~]@args[2]
        );
    }
}

# vim: ft=perl6
