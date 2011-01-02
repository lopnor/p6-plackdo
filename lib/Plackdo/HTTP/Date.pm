use v6;

module Plackdo::HTTP::Date {

    my @DoW = <Sun Mon Tue Wed Thu Fri Sat>;
    my @MoY = <Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec>;
    
    multi sub time2str (DateTime $d? is copy) is export {
        $d //= DateTime.now;
        my $utc = $d.utc;
        return sprintf('%s, %02d %s %04d %02d:%02d:%02d GMT',
            @DoW[$utc.day-of-week],
            $utc.day-of-month,
            @MoY[$utc.month - 1],
            $utc.year,
            $utc.hour, $utc.minute, $utc.second
        );
    }

}

# vim: ft=perl6 :
