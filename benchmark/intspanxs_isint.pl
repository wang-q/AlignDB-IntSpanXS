# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl AlignDB::IntSpanXS.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Time::HiRes qw{ time };
use YAML qw(Dump Load DumpFile LoadFile);

use Test::More tests => 1;
BEGIN { use_ok('AlignDB::IntSpanXS') }

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.


my ( $start, $end );
for my $i ( 2 .. 6 ) {
    printf( "step %d\n", $i );
    $start = time;
    test_add_range($i);
    $end = time;
    printf( "start %f end %f duration %f\n", $start, $end, $end - $start );
}

sub test_add_range {
    my $step = shift;

    my @vec1 = (
        1,   30,  32,  149, 153, 155, 159, 247, 250, 250, 253, 464,
        516, 518, 520, 523, 582, 585, 595, 600, 622, 1679
    );

    my @vec2 = ( 100, 1000000 );

    for my $i ( 1 .. 10000 ) {
        my $itsx = AlignDB::IntSpanXS->new;

        if ($step >= 2) {
            $itsx->add_range(@vec1);
        }
        if ($step >= 3) {
            $itsx->add_range(@vec2);
        }
        if ($step >= 4) {
           $itsx->as_string;
        }
        if ($step >= 5) {
            for my $j (1 .. 200) {
                $itsx->add($j);
            }
        }
        if ($step >= 6) {
            for my $j (1 .. 200) {
                $itsx->add_pair($j * 5, $j * 10);
            }
        }
    }
}
