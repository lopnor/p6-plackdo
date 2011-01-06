use v6;
use Plackdo::Component;

role Plackdo::Middleware does Plackdo::Component {

    has &!app;

    method wrap (&app) {
        &!app = &app;
        return self.to_app;
    }
}

# vim: ft=perl6 :
