use v6;
use Test;
use Plackdo::Handler::Standalone;
use Plackdo::HTTP::Request;

ok 1;

my $handler = Plackdo::Handler::Standalone.new;
{
    my %env;
    is $handler.parse_request('', %env), -2;
}
{
    my $req = Plackdo::HTTP::Request.new('GET', 'http://localhost:5000/');
    my %env;
    my $str = ~$req;
    my $bytes = $str.bytes;
    my $t0 = now;
    is $handler.parse_request($str, %env), $bytes;
    say now - $t0;
}
{
# safari GET request
    my $req = Plackdo::HTTP::Request.new(
        GET => 'http://localhost:5000/',
        headers => {
            Accept => 'application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5',
            User-Agent => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; ja-jp) AppleWebKit/533.19.4 (KHTML, like Gecko) Version/5.0.3 Safari/533.19.4',
            Accept-Language => 'ja-jp',
            Accept-Encoding => 'gzip, deflate',
            Connection => 'keep-alive',
            Referer => 'http://localhost:5000/'
        }
    );
    my %env;
    my $str = ~$req;
    my $bytes = $str.bytes;
    my $t0 = now;
    is $handler.parse_request($str, %env), $bytes;
    say now - $t0;
}
{
# firefox GET request
    my $req = Plackdo::HTTP::Request.new(
        GET => 'http://localhost:5000/foobar?foo=bar&hoge=fuga',
        headers => {
            "User-Agent" => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; ja-JP-mac; rv:1.9.2.12) Gecko/20101026 Firefox/3.6.12",
            "Accept" => "text/css,*/*;q=0.1",
            "Accept-Language" => "ja,en-us;q=0.7,en;q=0.3",
            "Accept-Encoding" => "gzip,deflate",
            "Accept-Charset" => "Shift_JIS,utf-8;q=0.7,*;q=0.7",
            "Keep-Alive" => "115",
            "Connection" => "keep-alive",
            "Referer" => "http://127.0.0.1:5000/"
        }
    );
    my %env;
    my $str = ~$req;
    my $bytes = $str.bytes;
    my $t0 = now;
    is $handler.parse_request($str, %env), $bytes;
    say now - $t0;
}
{
# chrome GET request
    my $req = Plackdo::HTTP::Request.new(
        GET => 'http://localhost:5000/foobar?foo=bar&hoge=fuga',
        headers => {
            "Connection" => "keep-alive",
            "Referer" => "http://127.0.0.1:5000/",
            "Accept" => "text/css,*/*;q=0.1",
            "User-Agent" => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Chrome/8.0.552.231 Safari/534.10",
            "Accept-Encoding" => "gzip,deflate,sdch",
            "Accept-Language" => "ja,en-US;q=0.8,en;q=0.6",
            "Accept-Charset" => "Shift_JIS,utf-8;q=0.7,*;q=0.3",
        }
    );
    my %env;
    my $str = ~$req;
    my $bytes = $str.bytes;
    my $t0 = now;
    is $handler.parse_request($str, %env), $bytes;
    say now - $t0;
}

done;
# vim: ft=perl6 :
