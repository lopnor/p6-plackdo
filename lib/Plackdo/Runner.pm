use v6;
use Plackdo::Util;

class Plackdo::Runner {
    has Str $!app = 'app.p6sgi';
    has Str $!handler = 'Standalone';
    has Str $!env = 'development';

    method run (*@args) {
        my $handler = self.load_handler(@args);
        my $app = self.load_app();
        $handler.run($app);
    }

    method load_app {
        my $app;
        try {
            $!app.IO.f or die;
            $app = eval slurp $!app;
        }
        return $app;
    }

    method load_handler (*@args) {
        my $handler = load_instance($!handler, "Plackdo::Handler");
        $handler.set_attr(@args) if @args;
        return $handler;
    }
}

# vim: ft=perl6 :
