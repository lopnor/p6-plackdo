use v6;
use Plackdo::TempBuffer;

class Plackdo::TempBuffer::File does Plackdo::TempBuffer {
    has $.filename;
    has $.fh;

    submethod BUILD () {
        $!filename = self.build_filename();
        $!fh = self.build_fh();
    }

    method build_filename {
        my $filename;
        while 1 {
            $filename = sprintf('/tmp/tmp_%05d', 100000.rand.Int);
            $filename.IO ~~ :e or last;
        }
        $filename;
    }

    method build_fh { 
        my $fh = open(self.filename, :w);
        $fh.autoflush;
        $fh;
    }

    method print (*@items) { self.fh.print(@items) }

    method close { self.fh.close }

    method rewind {
        self.fh.close;
        return open(self.filename, :r);
    }

    method unlink {
        self.fh.close;
        unlink self.filename;
    }
}

# vim: ft=perl6 :
