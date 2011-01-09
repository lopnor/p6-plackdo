use v6;

module Plackdo::Test {
    use Plackdo::HTTP::Request;
    use Plackdo::Util;

    our $Impl ||= %*ENV<PLACKDO_TEST_IMPL> || 'MockHTTP';

    sub test_p6sgi (&app, &client) is export {
        my $impl = $Impl;
        if ($impl eq 'Standalone') {
            $impl ~= '::'~ $*OS.ucfirst;
        }
        my $obj = load_instance($impl, 'Plackdo::Test');
        $obj.test_p6sgi(&app, &client);
    }

    multi sub new_request (Hash %in) is export {
        Plackdo::HTTP::Request.new(|%in);
    }

    multi sub new_request (Str $method, Str $uri) is export {
        Plackdo::HTTP::Request.new($method, $uri);
    }
}

# vim: ft=perl6 :
