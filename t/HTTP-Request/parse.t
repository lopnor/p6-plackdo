use v6;
use Test;
use Plackdo::HTTP::Request;

ok 1;

{
    my $str = Q{
GET / HTTP/1.1
Host: localhost:5000

};
    my $t0 = now;
    ok my $req = Plackdo::HTTP::Request.parse($str);
    say now - $t0;
}

done_testing;

# vim: ft=perl6 :
