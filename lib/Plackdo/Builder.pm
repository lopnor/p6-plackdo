use v6;

class Plackdo::Builder {
    use Plackdo::Middleware;

    has @!middleware;

    method add_middleware (Plackdo::Middleware $middleware) {
        @!middleware.push($middleware);
    }

    method to_app (&app is copy) {
        for @!middleware -> $m {
            &app = $m.wrap(&app);
        }
        return &app;
    }
}

# vim: ft=perl6 :
