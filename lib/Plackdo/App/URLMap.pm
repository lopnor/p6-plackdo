use v6;
use Plackdo::Component;

class Plackdo::App::URLMap does Plackdo::Component {
    has @!mapping;
    has @!sorted_mapping;

    method mount ($location, $app) { self.domap($location, $app) }

    method domap ($location is copy, $app) {
        my $host;
        # TODO Use URI?
        if $location ~~ / ^ http s? '://' ( .*? ) ( '/' .* ) / {
            $host     = $0;
            $location = $1;
        }

        if ($location !~~ / ^ '/' /) {
            # Carp::croak?
            die("Paths need to start with /");
        }
        $location ~~ s/\/$//;

        push @!mapping, [ $host, $location, $app ];
    }

    method prepare_app {
        # Sort by length of host, then path; longest first
        @!sorted_mapping = @!mapping.sort({
            ($^b[0] // '').chars <=> ($^a[0] // '').chars
            ||
            $^b[1].chars <=> $^a[1].chars
        });
    }

    method call (%env) {
        my $path_info   = %env<PATH_INFO>;
        my $script_name = %env<SCRIPT_NAME>;
        my $http_host   = %env<HTTP_HOST>;
        my $server_name = %env<SERVER_NAME>;

        if ($http_host and my $port = %env<SERVER_PORT>) {
            $http_host ~~ s/ \: $port $//;
        }

        for @!sorted_mapping -> $map {
            my $host = $map[0];
            my $location = $map[1];
            my $app = $map[2];
            my $path = $path_info; # Copy
            #note "Matching request (Host=$http_host Path=$path) and the map (Host=$host Path=$location)";
            next if $host.defined and $host eq none($http_host, $server_name);
            # RAKUDO: $str ~~ s/ ^ Not Matching Regex // still returns Bool::True
            #next unless $location eq '' or $path ~~ s/ ^ $location //;
            next unless $location eq '' or $path ~~ / ^ $location /; $path ~~ s/ ^ $location //;
            next unless $path eq '' or $path ~~ m/ ^ \/ /;
            #note "-> Matched!";

            my $orig_path_info   = %env<PATH_INFO>;
            my $orig_script_name = %env<SCRIPT_NAME>;

            %env<PATH_INFO>  = $path;
            %env<SCRIPT_NAME> = $script_name ~ $location;
            return self.response_cb($app(%env), sub ($res) {
                %env<PATH_INFO> = $orig_path_info;
                %env<SCRIPT_NAME> = $orig_script_name;
                return $res;
            });
        }

        #DEBUG && warn "All matching failed.\n";

        return [404, [ 'Content-Type' => 'text/plain' ], [ "Not Found" ]];
    }
}

# vim: ft=perl6
