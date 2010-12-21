use v6;
use Test;

use Plackdo::Runner;
ok 1;

{
    ok my $runner = Plackdo::Runner.new;
    ok my $handler = $runner.load_handler;
    is $handler.WHAT, 'Plackdo::Handler::Standalone()';
    dies_ok $runner.load_app;
}
{
    ok my $runner = Plackdo::Runner.new(
        app => 't/Runner/test.p6sgi'
    );
    ok my $app = $runner.load_app;
    is $app.WHAT, 'Sub()';
}


done_testing;
# vim: ft=perl6 :
