use v6;

class Plackdo::Socket is Cool does IO::Socket {

    method new {
        my $pio = Q:PIR {
            .local pmc pio
            pio = root_new ['parrot';'Socket']
            %r = pio
        };
        self.bless( *, PIO => $pio );
    }

    method socket(Int $domain, Int $type, Int $protocol) {
        my $pio = Q:PIR {
            .local pmc pio
            .local pmc domain
            .local pmc type
            .local pmc protocol
            pio = root_new ['parrot';'Socket']
            domain   = find_lex "$domain"
            type     = find_lex "$type"
            protocol = find_lex "$protocol"
            pio.'socket'(domain, type, protocol)
            %r = pio
        };
        self.bless( *, PIO => $pio);
    }

    method open(Str $host, Int $port) {
        my $sockaddr = self.sockaddr($host, $port);
        my $status = 0;

        try {
            $!PIO.connect(pir::descalarref__PP($sockaddr));
            CATCH {
                default { $status = 1; }
            }
        }
        return $status;
    }

    method bind(Str $host, Int $port) {
        my $sockaddr = self.sockaddr($host, $port);
        my $status = 0;

        try {
            $!PIO.bind(pir::descalarref__PP($sockaddr));
            CATCH {
                default { $status = 1; }
            }
        }
        return $status;
    }

    method sockaddr(Str $host, Int $port) {
        Q:PIR {
            .local pmc self, pio, host, port, sockaddr
            self = find_lex 'self'
            pio = getattribute self, '$!PIO'
            host = find_lex '$host'
            port = find_lex '$port'
            sockaddr = pio.'sockaddr'(host, port)
            %r = sockaddr
        };
    }


    method listen() {
        $!PIO.listen(1);
    }

    method accept() {
        return $!PIO.accept();
    }

    method remote_address() {
        return $!PIO.remote_address();
    }
}

# vim: ft=perl6 :
