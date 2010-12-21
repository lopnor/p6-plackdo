use v6;

grammar Plackdo::HTTP::Message::Grammar {
    regex TOP { <headers> [ <crlf> ** 2 <body> ]? }
    regex headers { <pair> ** <crlf> }
    regex pair { <key> ':'\s* <value> }
    regex value { <value_line> ** [ <crlf> [\t|' ']+ ] }
    regex value_line { [ \S | ' ' ]+ }
    regex crlf { \r?\n }
    regex key  { \S+ }
    token body { .+ }
}

# vim: ft=perl6 :
