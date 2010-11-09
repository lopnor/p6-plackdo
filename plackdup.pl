#!/usr/bin/env perl6
use v6;
BEGIN {@*INC.unshift('lib')}

use Plackdo::Runner;

sub MAIN (
    :$handler = 'Standalone', 
    :$app = 'app.p6sgi',
    :$env = 'development',
    *%rest
) {
    Plackdo::Runner.new(
        handler => $handler, 
        app => $app,
        env => $env,
    ).run(%rest);
}
