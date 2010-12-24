use v6;
use Plackdo::LWP::Protocol;

class Plackdo::LWP::Protocol::http does Plackdo::LWP::Protocol {
    use Plackdo::HTTP::Request;
    use Plackdo::HTTP::Response;

    method request (Plackdo::HTTP::Request $req) {

        my $sock = IO::Socket::INET.new;
        $sock.open($req.uri.host, $req.uri.port.Int, :bin);
        $sock.send("$req");
        my $response = $sock.recv();
        $sock.close;

        my $res = Plackdo::HTTP::Response.parse($response);
        return $res;
    }

}

# vim: ft=perl6 :
