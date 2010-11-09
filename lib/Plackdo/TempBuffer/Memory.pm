use v6;
use Plackdo::TempBuffer;

class Plackdo::TempBuffer::Memory does Plackdo::TempBuffer {
    has $!buffer;

    method print (*@items) { 
        for @items -> $item {
            $!buffer ~= $item;
        }
    }

    method rewind { return self }

    method slurp { return $!buffer }
}

# vim: ft=perl6
