use v6;

grammar Plackdo::URI::Grammar {
    regex TOP { ^ <scheme> '://' <host> [':'<port>]? <path_part> $ }
    token scheme { <[a..z0..9]>+ }
    token host   { <[a..z0..9\-\.]>+ }
    token port   { \d+ }
    token path_part { <path=.str> [ \? <query=.str> ]? [ \# <frag=.str> ]? }
    token str    { <-[\?\#]>+ }
}

# vim: ft=perl6 :
