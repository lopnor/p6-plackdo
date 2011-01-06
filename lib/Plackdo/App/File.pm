use v6;
use Plackdo::Component;

class Plackdo::App::File does Plackdo::Component {
    use Plackdo::Util;
    use Plackdo::MIME;
    use Plackdo::HTTP::Date;

    has $!root = '.';
    has $!encoding = 'utf-8';
    has $!conditional_get = 1;

    method call (%env is copy) {
        my ($file, $path_info) = self.locate_file(%env);
        return $file if $file.WHAT eq 'Array()';

        if $path_info {
            %env<PATH_INFO>.subst(/ $path_info $/,'');
            %env<SCRIPT_NAME> = %env<SCRIPT_NAME> ~ %env<PATH_INFO>;
            %env<PATH_INFO> = $path_info;
        } else {
            %env<SCRIPT_NAME> = %env<SCRIPT_NAME> ~ %env<PATH_INFO>;
            %env<PATH_INFO> = '';
        }
        
        self.serve_path(%env, $file);
    }

    method locate_file (%env) {
        my $path = %env<PATH_INFO>;
        
        $path ~~ m/\c0/ and return self.return_400;
        my $docroot = $!root;
        my @path = $path.split('/');
        if (+@path) {
            @path.shift if @path[0] eq '';
        } else {
            @path = <.>;
        }

        @path.grep('..') and return self.return_403;

        my ($file, @path_info);

        while +@path {
            my $try = join('/', $docroot, @path);
            if (self.should_handle($try)) {
                $file = $try;
                last;
            } elsif (! self.allow_path_info) {
                last;
            }
            @path_info.unshift(@path.pop);
        }

        unless ($file) {
            return self.return_404;
        }

# FIXME readable NYI
#        if (! $file.IO.r) {
#            return self.return_403;
#        }
        return $file, @path_info.unshift('').join('/');
    }

    method serve_path (%env, $path) {
        my $content_type = Plackdo::MIME::mime_type($path) // 'text/plain';
        
        if ($content_type ~~ m{ ^ 'text/' }) {
            $content_type ~= "; charset=$!encoding";
        }

        my $io = $path.IO;

        my $last_modified = time2str($io.changed);
        my $header = [
            Content-Type => $content_type,
            Content-Length => $io.stat.size,
            Last-Modified => $last_modified,
        ];

        if (%env<REQUEST_METHOD>.lc eq 'head') {
            return [200, $header, []];
        }

        if ($!conditional_get) {
            given %env<HTTP_IF_MODIFIED_SINCE>//'' {
                when $last_modified {
                    return [304, [Last-Modified => $last_modified], []];
                }
            }
        }

        my $content;
        try {
            $content = slurp $path;
            CATCH {
                my $fh = IO.new.open($path, :r, :bin);
                until $fh.eof {
                    $content ~= [~]$fh.read(4096).contents>>.chr;
                }
            }
        }

        return [ 200, $header, [ $content ] ];
    }

    method should_handle ($path) {
        return $path.IO.f;
    }

    method allow_path_info { 0 }

    method return_400 {
        [400, [Content-Type => 'text/plain', Content-Length => 11], ['Bad Request']];
    }
    method return_403 {
        [403, [Content-Type => 'text/plain', Content-Length => 9], ['Forbidden']];
    }
    method return_404 {
        [404, [Content-Type => 'text/plain', Content-Length => 9], ['Not Found']];
    }
}

# vim: ft=perl6
