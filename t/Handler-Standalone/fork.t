use v6;
use Test;
use NativeCall;
use LWP::Simple;
use Plackdo::Handler::Standalone;

ok 1;

sub fork returns Int is native<libc> { ... }

my $pid = fork();
if ($pid) {
    is LWP::Simple.get('http://localhost:5000/'), 'Hello, World';
} else {
    my $handler = Plackdo::Handler::Standalone.new;
    $handler.run(sub (%env){
        return [
            200,
            [
                Content-Type => 'text/plain',
                Content-Length => '12',
            ],
            ['Hello, World']
        ];
    });
}
run("kill $pid");

done_testing;

# vim: ft=perl6 :
