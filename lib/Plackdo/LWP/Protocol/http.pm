use v6;
use Plackdo::LWP::Protocol;

class Plackdo::LWP::Protocol::http does Plackdo::LWP::Protocol {
    use Plackdo::HTTP::Request;
    use Plackdo::HTTP::Response;
    use Plackdo::Socket;

    method request (Plackdo::HTTP::Request $req) {

        my $sock = Plackdo::Socket.socket(2,1,6);
        $sock.open($req.uri.host, $req.uri.port.Int);
        $sock.send("$req");
        my $response = $sock.recv();
        $sock.close;

        my $res = Plackdo::HTTP::Response.parse($response);
        return $res;
    }

}

# vim: ft=perl6 :
