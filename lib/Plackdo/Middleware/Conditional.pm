use v6;
use Plackdo::Middleware;

class Plackdo::Middleware::Conditional does Plackdo::Middleware {
    has &!condition;
    has $!middleware;

    method call (%env) {
        my &app = &!condition(%env) ?? $!middleware.wrap(&!app) !! &!app;
        return &app(%env);
    }
}

# vim: ft=perl6 :
