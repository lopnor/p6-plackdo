use v6;
use Plackdo::Middleware;

class Plackdo::Middleware::Static does Plackdo::Middleware {

    use Plackdo::App::File;

    has $!root = '.';
    has $!path;
    has $!file_app;
    has $!encoding;

    method call (%env) {
        my $res = self.handle_static(%env);
        return $res if $res;
        return &!app(%env);
    }

    method handle_static (%env) {
        $!path // return;
        my $path = %env<PATH_INFO>;
        $path ~~ $!path or return;
        $!file_app //= Plackdo::App::File.new(
            root => $!root,
            encoding => $!encoding,
        );

        return $!file_app.call(%env);
    }
}

# vim: ft=perl6
