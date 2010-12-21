use v6;

class Plackdo::HTTP::Headers {
    my @general_headers = <
        Cache-Control Connection Date Pragma Trailer Transfer-Encoding Upgrade
        Via Warning
    >;

    my @request_headers = <
        Accept Accept-Charset Accept-Encoding Accept-Language
        Authorization Expect From Host
        If-Match If-Modified-Since If-None-Match If-Range If-Unmodified-Since
        Max-Forwards Proxy-Authorization Range Referer TE User-Agent
    >;

    my @response_headers = <
        Accept-Ranges Age ETag Location Proxy-Authenticate Retry-After Server
        Vary WWW-Authenticate
    >;

    my @entity_headers = <
        Allow Content-Encoding Content-Language Content-Length Content-Location
        Content-MD5 Content-Range Content-Type Expires Last-Modified
    >;

    my %entity_header = map {; $_.lc => 1 }, @entity_headers; 

    my @header_order = (
        @general_headers, 
        @request_headers, 
        @response_headers, 
        @entity_headers
    );

    my $i;
    my %header_order;
    my %standard_case;
    for @header_order -> $key {
        %header_order{$key.lc} = ++$i;
        %standard_case{$key.lc} = $key;
    }

    has %!headers;

    method new (*%in) {
        self.bless(
            *,
            :headers( %in.pairs.map({;.key.lc => .value}) )
        );
    }

    multi method header(Str $name) {
        %!headers{ $name.lc };
    }

    multi method header(*%in) {
        for %in.pairs -> $pair {
            %!headers{$pair.key.lc} = $pair.value;
        }
    }

    method sorted_field_names {
        return %!headers.keys.sort( 
            { %header_order{ $^a } <=> %header_order{ $^b } } 
        );
    }

    method Str() {
        my $out;
        for self.sorted_field_names -> $key {
            $out ~= sprintf("%s: %s\n", %standard_case{$key}, %!headers.{ $key });
        }
        return $out;
    }
}

# vim: ft=perl6 :
