#!/usr/bin/env perl

use Mojo::Base -strict;

use Clone qw(clone);
use Test::More;

use Advent::Grid::Dense::Square;

require_ok 'Advent::Utils::Transform';

use Advent::Utils::Transform qw(
    reverse_rows
    rotate_clockwise
    transpose
);

my $width;
my $height = 0;
my @grid = ();
open (my $fh, '<', 't/data/test_transform');
while (<$fh>) {
    chomp;

    my @l = split //;
    $width = scalar @l if !defined $width;
    push @grid, @l;
    $height++;
}

# transpose
{
    my $g = clone(\@grid);
    transpose($g, $width, $height);
    my $mappings = {
        0 => 0,
        7 => 5,
        4 => 4,
    };

    while (my ($to, $from) = each %$mappings) {
        cmp_ok( $g->[$to], '==', $grid[$from] );
    }
}

# reverse_rows
{
    my $g = clone(\@grid);
    reverse_rows($g, $width, $height);
    my $mappings = {
        0 => 2,
        7 => 7,
        4 => 4,
        2 => 0,
    };

    while (my ($to, $from) = each %$mappings) {
        cmp_ok( $g->[$to], '==', $grid[$from] );
    }
}

# rotate_clockwise
# compare rotation to component parts
{
    my $g = clone(\@grid);
    rotate_clockwise($g, $width, $height);
    my $mappings = {
        0 => 6,
        7 => 5,
        4 => 4,
        2 => 0,
    };

    while (my ($to, $from) = each %$mappings) {
        cmp_ok( $g->[$to], '==', $grid[$from] );
    }

    my $g2 = clone(\@grid);
    transpose($g2, $width, $height);
    reverse_rows($g, $width, $height);

    is_deeply($g, $g2);
}

done_testing();

__END__
rotate_clockwise(rotate_clockwise(\@grid, $width, $height), $width, $height);
