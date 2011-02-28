use v6;
use Test;
use Plackdo::HTTP::Message;
use Plackdo::HTTP::Headers;

{
    ok my $message = Plackdo::HTTP::Message.new;
}
{
    ok my $message = Plackdo::HTTP::Message.new(
        Plackdo::HTTP::Headers.new(
            Content-Type => 'text/html',
            Content-Length => 11,
        ),
        '<html></html>'
    );
    ok $message.header(Connection => 'close');
    is $message.header('Connection'), 'close';
    is $message.header('Content-Type'), 'text/html';

    is "{$message}", join("\n",
        'Connection: close',
        'Content-Length: 11',
        'Content-Type: text/html',
        '',
        '<html></html>'
    );
} 



done;

# vim: ft=perl6 :
