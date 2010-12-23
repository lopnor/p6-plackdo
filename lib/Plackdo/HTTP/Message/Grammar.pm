use v6;

grammar Plackdo::HTTP::Message::Grammar {
    regex TOP { <headers> [ <crlf> ** 2 <content> ]? }
    regex headers { <pair> ** <crlf> }
    regex pair { <key> ':'\s* <value> }
    regex value { <value_line> ** [ <crlf> [\t|' ']+ ] }
    regex value_line { [ \S | ' ' ]+ }
    regex crlf { \r?\n }
    regex key  { \S+ }
    token content { .+ }
}

# vim: ft=perl6 :
