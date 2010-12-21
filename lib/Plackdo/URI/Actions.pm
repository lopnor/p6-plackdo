use v6;

class Plackdo::URI::Actions {
    use Plackdo::URI;

    method TOP ($/) { 
        my $port = $<port> ?? +$<port>[0].Str !! 
            $<scheme>.Str eq 'http' ?? 80 !!
            $<scheme>.Str eq 'https' ?? 443 !! Mu;
        make Plackdo::URI.new(
            scheme   => $<scheme>.Str,
            host     => $<host>.Str,
            port     => $port,
            path     => $<path_part><path>.Str,
            query    => $<path_part><query>.Str,
            fragment => $<path_part><frag>.Str,
        );
    }
}

# vim: ft=perl6 :
