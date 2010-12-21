use v6;

module Plackdo::Util {

    sub load_instance ($class, $prefix) is export {
        my $loaded_class = load_class($class, $prefix) or return;
        return eval "{$loaded_class}.new";
    }

    sub load_class ($class is rw, $prefix) is export {
        my $classname = $class;
        if $prefix  {
            unless ($class ~~ m/^\+/ || $class ~~ m/^$prefix/) {
                $classname = join('::', $prefix, $class);
            }
            $classname.subst(/^\+/,'');
        }
        try {
            require $classname;
            CATCH {
                default {$classname = ''; }
            }
        }
        return $classname;
    }

    sub str_to_hash ($str, %hash) is export {
        for $str.split('&') -> $item {
            my @pair = $item.split('=');
            +@pair == 2 or next;
            %hash{@pair[0]} = unescape( @pair[1] );
        }
    }

    # from November::CGI
    sub unescape ($string is rw) is export {
        $string .= subst('+', ' ', :g);
        # RAKUDO: This could also be rewritten as a single .subst :g call.
        #         ...when the semantics of .subst is revised to change $/,
        #         that is.
        # The percent_hack can be removed once the bug is fixed and :g is
        # added
        while $string ~~ / ( [ '%' <[0..9A..F]>**2 ]+ ) / {
            $string .= subst( ~$0,
            percent_hack_start( decode_urlencoded_utf8( ~$0 ) ) );
        }
        return percent_hack_end( $string );
    }

    sub percent_hack_start($str is rw) {
        if $str ~~ '%' {
            $str = '___PERCENT_HACK___';
        }
        return $str;
    }

    sub percent_hack_end($str) {
        return $str.subst('___PERCENT_HACK___', '%', :g);
    }

    sub decode_urlencoded_utf8($str) {
        my $r = '';
        my @chars = map { :16($_) }, $str.split('%').grep({$^w});
        while @chars {
            my $bytes = 1;
            my $mask  = 0xFF;
            given @chars[0] {
                when { $^c +& 0xF0 == 0xF0 } { $bytes = 4; $mask = 0x07 }
                when { $^c +& 0xE0 == 0xE0 } { $bytes = 3; $mask = 0x0F }
                when { $^c +& 0xC0 == 0xC0 } { $bytes = 2; $mask = 0x1F }
            }
            my @shift = (^$bytes).reverse.map({6 * $_});
            my @mask  = $mask, 0x3F xx $bytes-1;
            $r ~= chr( [+] @chars.splice(0,$bytes) »+&« @mask »+<« @shift );
        }
        return $r;
    }

}

# vim: ft=perl6
