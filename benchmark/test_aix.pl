#!/usr/bin/perl
use strict;
use warnings;

use Time::HiRes qw{ time };
use YAML qw(Dump Load DumpFile LoadFile);

use AlignDB::IntSpanXS;

run_test();
run_benchmark();

sub run_test {
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
}

sub run_benchmark {
    my ( $start, $end );
    for my $i ( 2 .. 6 ) {
        printf( "step %d\n", $i );
        $start = time;
        test_add_range($i);
        $end = time;
        printf( "duration %f\n", $end - $start );
    }
}

sub test_add_range {
    my $step = shift;

    my @vec1 = (
        1,   30,  32,  149, 153, 155, 159, 247, 250, 250, 253, 464,
        516, 518, 520, 523, 582, 585, 595, 600, 622, 1679
    );

    my @vec2 = ( 100, 1000000 );

    for my $i ( 1 .. 50000 ) {
        my $itsx = AlignDB::IntSpanXS->new;

        if ( $step >= 2 ) {
            $itsx->add_range(@vec1);
        }
        if ( $step >= 3 ) {
            $itsx->add_pair(@vec2);
        }
        if ( $step >= 4 ) {
            $itsx->as_string;
        }
        if ( $step >= 5 ) {
            for my $j ( 1 .. 200 ) {
                $itsx->add_pair( $j, $j );
            }
        }
        if ( $step >= 6 ) {
            for my $j ( 1 .. 200 ) {
                $itsx->add_range( $j * 5, $j * 10 );
            }
        }
    }
}
