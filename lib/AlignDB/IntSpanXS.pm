package AlignDB::IntSpanXS;
use strict;
use warnings;
use Carp;

use base qw( DynaLoader AlignDB::IntSpan );
use Scalar::Util qw(blessed);
use Scalar::Util::Numeric qw(isint);

use overload (
    q{0+}   => sub { confess "Can't numerify an AlignDB::IntSpanXS\n" },
    q{bool} => q{is_not_empty},
    q{""}   => q{runlist},

    # use Perl standard behaviours for other operations
    fallback => 1,
);

BEGIN {
    our $VERSION = '1.0.1';
    bootstrap AlignDB::IntSpanXS, $VERSION;
}

sub new {
    my $class = shift;
    my $self  = _new($class);
    $self->add(@_) if @_ > 0;
    return $self;
}

sub edges_ref {
    my $self = shift;
    return [ $self->edges ];
}

sub sets {
    my $self = shift;

    my @sets;
    my @ranges = $self->ranges;
    while (@ranges) {
        my $lower = shift @ranges;
        my $upper = shift @ranges;
        push @sets, blessed($self)->new("$lower-$upper");
    }

    return @sets;
}

sub contains_all {
    my $self = shift;

    for my $i (@_) {
        return 0 unless $self->_contains($i);
    }

    return 1;
}

sub contains_any {
    my $self = shift;

    for my $i (@_) {
        return 1 if $self->_contains($i);
    }

    return 0;
}

sub add {
    my $self  = shift;
    my $first = shift;

    if ( ref $first eq __PACKAGE__ ) {
        $self->add_range( $first->ranges );
    }
    elsif ( isint($first) ) {
        if ( scalar @_ > 0 ) {
            $self->add_array( [ $first, @_ ] );
        }
        else {
            $self->add_int($first);
        }
    }
    else {
        $self->add_runlist($first);
    }

    return $self;
}

sub remove {
    my $self  = shift;
    my $first = shift;

    if ( ref $first eq __PACKAGE__ ) {
        $self->remove_range( $first->ranges );
    }
    elsif ( isint($first) ) {
        if ( scalar @_ > 0 ) {
            $self->remove_array( [ $first, @_ ] );
        }
        else {
            $self->remove_int($first);
        }
    }
    else {
        $self->remove_runlist($first);
    }

    return $self;
}

sub union {
    my $self = shift;

    my $new = $self->copy;
    $new->merge(@_);

    return $new;
}

sub intersect {
    my $self = shift;

    my $new = $self->complement;
    for my $supplied (@_) {
        my $temp_set = $self->_real_set($supplied)->complement;
        $new->merge($temp_set);
    }
    $new->invert;

    return $new;
}

sub find_islands {
    my $self     = shift;
    my $supplied = shift;

    my $island;
    if ( ref $supplied eq __PACKAGE__ ) {
        $island = $self->_find_islands_set($supplied);
    }
    elsif ( isint($supplied) ) {
        $island = $self->_find_islands_int($supplied);
    }
    else {
        confess "Don't know how to deal with input to find_island\n";
    }

    return $island;
}

sub _find_islands_int {
    my $self   = shift;
    my $number = shift;

    my $island = blessed($self)->new;

    # if $pos & 1, i.e. $pos is odd number, $val is in the set
    my $pos = $self->_find_pos( $number + 1, 0 );
    if ( $pos & 1 ) {
        my @ranges = $self->ranges;
        $island->add_range( $ranges[ $pos - 1 ], $ranges[$pos] );
    }

    return $island;
}

sub nearest_island {
    my $self     = shift;
    my $supplied = shift;

    if ( ref $supplied eq __PACKAGE__ ) {    # just OK
    }
    elsif ( isint($supplied) ) {
        $supplied = blessed($self)->new($supplied);
    }
    else {
        confess "Don't know how to deal with input to nearest_island\n";
    }

    my $island = blessed($self)->new;
    my $min_d;
    for my $s ( $self->sets ) {
        for my $ss ( $supplied->sets ) {
            next if $s->overlap($ss);
            my $d = $s->distance($ss);
            if ( !defined $min_d or $d <= $min_d ) {
                if ( defined $min_d and $d == $min_d ) {
                    $island->merge($s);
                }
                else {
                    $min_d  = $d;
                    $island = $s->copy;
                }
            }
        }
    }

    return $island;
}

sub runlist      { shift->as_string; }
sub run_list     { shift->as_string; }
sub elements     { shift->as_array; }
sub size         { shift->cardinality; }
sub count        { shift->cardinality; }
sub empty        { shift->is_empty; }
sub contains     { shift->contains_all(@_); }
sub contain      { shift->contains_all(@_); }
sub member       { shift->contains_all(@_); }
sub duplicate    { shift->copy; }
sub intersection { shift->intersect(@_); }
sub equals       { shift->equal(@_); }
sub join_span    { shift->fill(@_); }

1;    # Magic true value required at end of module

__END__

=pod

=encoding UTF-8

=head1 NAME

AlignDB::IntSpanXS - XS version of AlignDB::IntSpan.

=head1 SYNOPSIS

    use AlignDB::IntSpanXS;

    my $set = AlignDB::IntSpanXS->new;
    $set->add(1, 2, 3, 5, 7, 9);
    $set->add_range(100, 1_000_000);
    print $set->as_string, "\n";    # 1-3,5,7,9,100-1000000

=head1 AUTHOR

Qiang Wang <wang-q@outlook.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2008 by Qiang Wang.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
