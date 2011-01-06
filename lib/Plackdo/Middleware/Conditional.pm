use v6;
use Plackdo::Middleware;

class Plackdo::Middleware::Conditional does Plackdo::Middleware {
    has &!condition;
    has $!middleware;
    has $!mw;

    method prepare_app {
        $!middleware or die;
        $!mw = $!middleware.wrap(&!app);
    }

    method call (%env) {
        my &app = &!condition(%env) ?? $!mw !! &!app;
        return &app(%env);
    }
}

# vim: ft=perl6 :
