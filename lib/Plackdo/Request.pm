use v6;

class Plackdo::Request {
    use Plackdo::Util;
    use Plackdo::TempBuffer::File;
    use Plackdo::URI;

    has %!env;
    has %!params;
    has %!uploads;

    multi method new (*%in) {
        self.bless(
            *,
            env => %in
        );
    }

    method uri {
        return Plackdo::URI.new(%!env<REQUEST_URI>);
    }

    method request_method {
        return %!env<REQUEST_METHOD>;
    }

    method parameters {
        self!parse_parameters unless %!params;
        return %!params;
    }

    method !parse_parameters {
        self!parse_query_parameters();
        self!parse_body_parameters();
    }

    method !parse_query_parameters {
        str_to_hash(%!env<QUERY_STRING> // '', %!params);
    }

    method !parse_body_parameters {
        my $len = %!env<CONTENT_LENGTH> or return;
        my $body = %!env<psgi.input>.slurp.substr(0, $len);
        given %!env<CONTENT_TYPE>.split(';').[0] {
            when 'application/x-www-form-urlencoded' {
                str_to_hash($body, %!params);
            }
            when 'multipart/form-data' {
                my $b = %!env<CONTENT_TYPE> ~~ m/ boundary\=(.+)$ / ?? $/.[0] !! return;
                for $body.split('--'~$b) -> $part {
                    $part ~~ m/ ^(.*?)\r?\n\r?\n / or next;
                    my $header = $/[0];
                    my $body = $part.subst( / ^[.*?]\r?\n\r?\n /, '');
                    my $name = $header ~~ m/ name\=\"(.*?)\" / ?? $/.[0] !! '';
                    if ($header ~~ m/filename\=\"(.*?)\"/) {
                        my $filename = $/.[0];
                        my $tmp = Plackdo::TempBuffer::File.new;
                        $tmp.print($body);
                        $tmp.close;
                        %!uploads{$name} = $tmp.filename;
                        %!params{$name} = $filename;
                    } else {
                        %!params{$name} = $body.chomp;
                    }
                }
            }
        }
    }

    method param ($name) {
        return self.parameters{$name};
    }

    method upload ($name) {
        return self.uploads{$name};
    }

    submethod DESTORY {
        say 'destroy';
    }
}

# vim: ft=perl6
