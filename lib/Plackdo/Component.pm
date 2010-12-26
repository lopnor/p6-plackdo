use v6;

role Plackdo::Component {

    method prepare_app { return }

    method call (&env) { ... }

    method to_app (*@args) {
        self.prepare_app;

        return sub (%env) { self.call(%env) };
    }

    method response_cb ($res, &cb) {
        return &cb($res);
    }
}

# vim: ft=perl6 :
