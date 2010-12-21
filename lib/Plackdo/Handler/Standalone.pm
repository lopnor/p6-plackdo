use v6;
use Plackdo::Handler;
use Plackdo::TempBuffer::Memory;

sub PF_INET {2}
sub SOCK_STREAM {1}
sub TCP {6}

my %status = 
    200 => 'OK',
    500 => 'Internal Server Error';

class Plackdo::Handler::Standalone does Plackdo::Handler {
    has Str $.host is rw = '0.0.0.0';
    has Int $.port is rw = 5000;

    method set_attr (*%args) {
        for %args.pairs {
            my $value = .value;
            given .key {
                when 'host' {$.host = $value}
                when 'port' {$.port = $value}
            }
        }
    }

    submethod run ($app) {
        my $server = IO::Socket::INET.socket( PF_INET, SOCK_STREAM, TCP );
        $server.bind( $.host, $.port );
        $server.listen();

        say "ready for access on http://{$.host}:{$.port}/";
        while my $conn = $server.accept() {
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
                    $res = self.make_response($app(%env));
                    last;
                }
            }
            $conn.send($res);
            $conn.close;
            $tmpfile.unlink if $tmpfile;
        }
   }

    method parse_request ($chunk, %env) {
        my $pred = $chunk ~~ m/^(\r?\n)+/ and $/.[0] // '';
        my $head = $chunk.subst(/^(\r?\n)+/, '');
        $head ~~ / ^(.*?)\r?\n\r?\n / or return -2;
        $head = $/;
        my @lines = $head.split(/\r?\n/);
        my ($method, $uri, $proto) = @lines.shift.split(' ');
        my ($path, $query_string) = $uri.split('?');
        $query_string = '' if $query_string !~~ Str;

        %env<SCRIPT_NAME> = '';
        %env<PATH_INFO> = $path;
        %env<SERVER_PORT> = $.port;
        %env<SERVER_ADDR> = $.host;
        %env<SERVER_PROTOCOL> = $proto;
        %env<REQUEST_METHOD> = $method;
        %env<REQUEST_URI> = $uri;
        %env<QUERY_STRING> = $query_string;

        for @lines -> $line {
            my ($key, $value) = $line.split(/\:\s+/);
            $key or next;
            $key = $key.uc.subst('-', '_', :g);
            unless ( $key eq any <CONTENT_TYPE CONTENT_LENGTH> ) {
                $key = 'HTTP_'~$key
            }
            %env{$key} = $value;
        }
        return $head.chars + $pred.chars;
    }

    method make_response (@args) {
        my $status = @args[0];
        my $headers;
        for @args[1].hash {
            $headers ~= join(": ", .key, .value) ~ "\r\n";
        }

        return join("\r\n",
            join(' ', "HTTP/1.0", $status, %status{$status}),
            $headers,
            [~]@args[2]
        );
    }
}

# vim: ft=perl6
