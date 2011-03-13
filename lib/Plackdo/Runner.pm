use v6;
use Plackdo::Util;

class Plackdo::Runner {
    has Str $!app = 'app.p6sgi';
    has Str $!handler = 'Standalone';
    has Str $!env = 'development';
    has @.middleware;

    method run (*%args) {
        my $handler = self.load_handler(|%args);
        my $app = self.load_app();
        if ($app ~~ Exception) {
            die 'could not load p6sgi file:' ~ $app;
        }
        for @.middleware -> $name {
            my $mw = load_instance($name, 'Plackdo::Middleware') or next;
            $app = $mw.wrap($app);
        }
        if ($!env eq 'development') {
            my $mw = load_instance('AccessLog', 'Plackdo::Middleware');
            $app = $mw.wrap($app);
            $handler.server_ready = sub {
                say( 'ready for access on http://' ~ $handler.host ~ ':' ~ $handler.port ~ '/' );
            };
        }
        $handler.run($app);
    }

    method load_app {
        my $app;
        try {
            $!app.IO.f or die "{$!app} not found";
            $app = eval slurp $!app;
            my $error = $!;
            die $error if $error;
            CATCH {
                default { 
                    $app := $!;
                };
            }
        }
        return $app;
    }

    method load_handler (*%args) {
        my $handler = load_instance($!handler, "Plackdo::Handler") or die;
        $handler.set_attr(|%args) if %args;
        return $handler;
    }
}

# vim: ft=perl6 :
