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

my $itx = AlignDB::IntSpanXS->new;
print Dump {
    POS_INF      => $itx->POS_INF,
    NEG_INF      => $itx->NEG_INF,
    EMPTY_STRING => $itx->EMPTY_STRING,
};
print Dump $itx->as_string;
$itx->add_range( 1, 9, 20, 39 );
print Dump {
    edge_size    => $itx->edge_size,
    edges        => [ $itx->edges ],
    ranges       => [ $itx->ranges ],
    is_empty     => $itx->is_empty,
    is_not_empty => $itx->is_not_empty,
    as_string    => $itx->as_string,
};

for ( -5, 29, 100 ) {
    printf "val %d contain %d\n", $_, $itx->contains($_);
}

my @array = ( 5, 30 );
printf "contains_all %d\n", $itx->contains_all(@array);
printf "contains_any %d\n", $itx->contains_any(@array);
push @array, -5;
printf "contains_all %d\n", $itx->contains_all(@array);
printf "contains_any %d\n", $itx->contains_any(@array);

@array = ( 60, 70, 80, 90 );
$itx->add_range(@array);
print Dump $itx->as_string;

@array = ( 68, 75 );
$itx->add_range(@array);
print Dump $itx->as_string;

$itx->add(99);
print Dump $itx->as_string;

$itx->add( 77, 79 );
print Dump $itx->as_string;

$itx->invert;
print Dump $itx->as_string;

$itx->invert;
print Dump $itx->as_string;

$itx->remove_range( 66, 71 );
print Dump $itx->as_string;

$itx->remove(85);
print Dump $itx->as_string;

$itx->remove( 87, 88 );
print Dump $itx->as_string;

$itx->add("-30--10");
print Dump $itx->as_string;

$itx->remove("62-78");
print Dump $itx->as_string;

my $supp = AlignDB::IntSpanXS->new("-15-5");
print Dump $supp->as_string;
$itx->add($supp);
print Dump $itx->as_string;

$supp->clear;
print Dump $supp->as_string;
$supp->add("-20--5");
print Dump $supp->as_string;
$itx->remove($supp);
print Dump $itx->as_string;
print Dump $itx;

my $itx_copy = $itx->copy;
print Dump $itx_copy->as_string;
print Dump $itx_copy;

{
    my @test_array = (
        1 .. 30,
        32 .. 149,
        153 .. 155,
        159 .. 247,
        250,
        253 .. 464,
        516 .. 518,
        520 .. 523,
        582 .. 585,
        595 .. 600,
        622 .. 1679,
    );

    for my $step ( 1 .. 4 ) {
        print '-' x 60, "\n";
        print "Benchmark 1, including object startup.\nStep $step: \n";

        my $set = AlignDB::IntSpanXS->new if $step >= 1;
        if ( $step >= 2 ) {
            $set->add_array(\@test_array);
        }
        $set->add_range( 100, 1_000_000 ) if $step >= 3;
        $set->as_string if $step >= 4;

    }
}

