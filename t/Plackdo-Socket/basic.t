use v6;
use Test;
use Plackdo::Socket;
ok 1;

ok my $sock = Plackdo::Socket.socket(2, 1, 6);
isa_ok $sock, Plackdo::Socket;

my $result = $sock.bind('127.0.0.1', 5000);
is $result, 0;
$sock.listen;

ok my $sock2 = Plackdo::Socket.socket(2,1,6);
isa_ok $sock2, Plackdo::Socket;

my $result2 = $sock2.bind('127.0.0.1', 5000);
say $result2;
isnt $result2, 0;

$sock.close;

done;

# vim: ft=perl6 :
