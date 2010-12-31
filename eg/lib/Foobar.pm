use v6;
use Plackdo::Request;

class Foobar {
    method webapp {
        return sub (%env) {
            return self.handle_request(%env);
        };
    }

    method handle_request (%env) {
        my $req = Plackdo::Request.new(|%env);
#        my $fh = %env.delete('psgi.input');
#        my $body = $fh ?? $fh.slurp !! '';
        my $content = "<html>"
            ~ '<head><meta http-equiv="Content-Type" content="text/html; charset=UTF8" />'
            ~ "</head><body>"
            ~ qq{<form method="POST" enctype="multipart/form-data">}
            ~ '<table>'
            ~ '<tr><th>subject</th><td><input type="text" name="subject"></td></tr>'
            ~ '<tr><th>file</th><td><input type="file" name="file"></td></tr>'
            ~ '<tr><th>body</th><td><textarea name="body"></textarea></td></tr>'
            ~ '<tr><th></th><td><input type="submit" value="multipart/form-data"></td></tr>'
            ~ '</table>'
            ~ '</form>'
            ~ qq{<form method="POST">}
            ~ '<table>'
            ~ '<tr><th>subject</th><td><input type="text" name="subject"></td></tr>'
            ~ '<tr><th>body</th><td><textarea name="body"></textarea></td></tr>'
            ~ '<tr><th></th><td><input type="submit" value="application/x-www-form-urlencoded"></td></tr>'
            ~ '</table>'
            ~ '</form>'
            ~ "<pre>{%env}</pre>"
#            ~ "<h2>here is body content</h2>"
#            ~ "<pre>{$body}</pre>"
            ~ "<h2>here is Plackdo::Request parameters</h2>"
            ~ "<pre>{$req.parameters()}</pre>"
            ~ "</body></html>";

        return
            200,
            ( Content-Type => 'text/html; chrset=UTF8' ),
            ( $content );

    }
}

# vim: set ft=perl6 :
