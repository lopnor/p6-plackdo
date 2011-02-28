use v6;

use Test;
use Plackdo::Util;

ok my $classname = load_class('Standalone', 'Plackdo::Handler'), 'load_class ok';
is $classname, 'Plackdo::Handler::Standalone';
ok my $ins = load_instance('Standalone', 'Plackdo::Handler'), 'load_instance ok';
is $ins.WHAT, 'Plackdo::Handler::Standalone()';


ok ! load_class('NotExistingHandler', 'Plackdo::Handler');
ok ! load_instance('NotExistingHandler', 'Plackdo::Handler');

done;

# vim:ft=perl6
