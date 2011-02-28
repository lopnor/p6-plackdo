use v6;
use Test;

use Plackdo::Runner;
ok 1;

{
    ok my $runner = Plackdo::Runner.new;
    ok my $handler = $runner.load_handler;
    is $handler.WHAT, 'Plackdo::Handler::Standalone()';
    is $handler.host, '0.0.0.0';
    is $handler.port, 5000;
    ok my $handler1 = $runner.load_handler(host => '192.168.0.1');
    is $handler1.WHAT, 'Plackdo::Handler::Standalone()';
    is $handler1.host, '192.168.0.1';
    is $handler1.port, 5000;
    ok my $handler2 = $runner.load_handler(port => 3000);
    is $handler2.WHAT, 'Plackdo::Handler::Standalone()';
    is $handler2.host, '0.0.0.0';
    is $handler2.port, 3000;
    ok my $handler3 = $runner.load_handler(port => 3001, host => '192.168.0.2');
    is $handler3.WHAT, 'Plackdo::Handler::Standalone()';
    is $handler3.host, '192.168.0.2';
    is $handler3.port, 3001;
}
{
    ok my $runner = Plackdo::Runner.new;
    ok my $handler = $runner.load_handler;
    is $handler.WHAT, 'Plackdo::Handler::Standalone()';
    is $handler.host, '0.0.0.0';
    is $handler.port, 5000;
    ok ! $runner.load_app;
#    dies_ok { $runner.load_app };
}
{
    ok my $runner = Plackdo::Runner.new(
        app => 't/Plackdo-Runner/test.p6sgi'
    );
    ok my $app = $runner.load_app;
    is $app.WHAT, 'Sub()';
}
{
    ok my $runner = Plackdo::Runner.new(
        app => 't/Plackdo-Runner/fail.p6sgi'
    );
    my $app = $runner.load_app;
    is $app.WHAT, 'Failure()'; 
}
{
    ok my $runner = Plackdo::Runner.new(
        app => 't/Plackdo-Runner/nonexisting.p6sgi'
    );
    my $app = $runner.load_app;
    is $app.WHAT, 'Any()'; 
}

done;
# vim: ft=perl6 :
