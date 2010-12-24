use v6;

grammar Plackdo::URI::Grammar {
    regex TOP { ^ [ <scheme> '://' <host> [':'<port>]? ]? <path_part> $ }
    token scheme { <[a..z0..9]>+ }
    token host   { <[a..z0..9\-\.]>+ }
    token port   { \d+ }
    token path_part { <path=.str> [ \? <query=.str> ]? [ \# <frag=.str> ]? }
    token str    { <-[\?\#]>+ }
}

class Plackdo::URI::Actions {

    method TOP ($/) { 
        make { 
            scheme   => $<scheme>.Str,
            host     => $<host>.Str,
            $<port> ?? port => $<port>[0].Str !! (),
            path     => $<path_part><path>.Str,
            query    => $<path_part><query>.Str,
            fragment => $<path_part><frag>.Str,
        };
    }
}

class Plackdo::URI {
    has $.scheme is rw;
    has $.host is rw;
    has $.port is rw;
    has $.path is rw;
    has $.query is rw;
    has $.fragment is rw;

    multi method new (Hash *%in) {
        my %default_port = (
            http => 80,
            https => 443,
        );
        %in<port> = %default_port{ %in<scheme> } unless %in<port>;
        self.bless( *, |%in );
    }

    multi method new (Str $in) {
        my $m = Plackdo::URI::Grammar.parse(
            $in, actions => Plackdo::URI::Actions
        );
        return self.new(|$m.ast);
    }

    method host_port {
        $.host or return;
        $.host ~ ( 
            ($.scheme eq 'http' && $.port == 80) ?? () !!
            ($.scheme eq 'https' && $.port == 443) ?? () !!
            ':' ~ $.port
        )
    }

    method Str() {
        my $host_port = self.host_port();
        ( $host_port ?? ($.scheme ~ '://' ~ $host_port) !! () )
        ~ ( $.path // '/' )
        ~ ( $.query ?? '?' ~ $.query !! () )
        ~ ( $.fragment ?? '#' ~ $.fragment !! () )
    }

}

# vim: ft=perl6 :
