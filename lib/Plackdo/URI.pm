use v6;

class Plackdo::URI {
    use Plackdo::URI::Grammar;
    use Plackdo::URI::Actions;

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
        return $m.ast;
    }

    method Str() {
        $.scheme ~ '://' ~ $.host ~ ( 
            ($.scheme eq 'http' && $.port == 80) ?? () !!
            ($.scheme eq 'https' && $.port == 443) ?? () !!
            ':' ~ $.port
        )
        ~ ( $.path // '' )
        ~ ( $.query ?? '?' ~ $.query !! () )
        ~ ( $.fragment ?? '#' ~ $.fragment !! () )
    }

}

# vim: ft=perl6 :
