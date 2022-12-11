package Advent::Utils::Transform;

use Mojo::Base 'Exporter';

our @EXPORT_OK = qw(
    print_grid
    reverse_rows
    rotate_clockwise
    transpose
);

# TODO:
# - rotate anti-clockwise
# - reverse columns

# print a 2d grid represented by a 1d arrayref
# 0,0 top left
# prints a trailing newline
sub print_grid {
    my ($grid, $width, $height) = @_;

    for my $y (0..$height - 1) {
        for my $x (0..$width - 1) {
            print $grid->[$y * $width + $x];
        }
        print "\n";
    }
    print "\n";
}

# rotate 90 degrees clockwise a 2d grid represented by a 1d arrayref
sub rotate_clockwise {
    my ($grid, $width, $height) = @_;
    transpose($grid, $width, $height);
    reverse_rows($grid, $width, $height);
    return $grid;
}

# reverse the rows in a 2d grid represented by a 1d arrayref
# eqivalent to a horizontal flip
# flips in place
sub reverse_rows {
    my ($grid, $width, $height) = @_;
    
    for my $y (0..$height - 1) {
        my $from = $y * $width;
        my $to = $y * $width + ($width - 1);
        my @row = @$grid[$from..$to];
        @row = reverse @row;
        splice @$grid, $from, $width, @row;
    }

    return $grid;
}

# transposes a 2d grid represented by a 1d arrayref
# 
# [ 1, 2, 3 ]
# [ 4, 5, 6 ]
# [ 7, 8, 9 ]
# is =>
# [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]
#
# we want
# [ 1, 4, 7 ]
# [ 2, 5, 8 ]
# [ 3, 6, 9 ]
# is =>
# [ 1, 4, 7, 2, 5, 8, 3, 6, 9 ]
#
# swaps in place
sub transpose {
    my ($grid, $width, $height) = @_;

    for my $y (0..$height - 1) {
        for my $x (0..($y - 1)) {
            my $oldi = $y * $width + $x;
            my $newi = $x * $width + $y;
            my $temp = $grid->[$oldi];
            $grid->[$oldi] = $grid->[$newi];
            $grid->[$newi] = $temp;
        }
    }

    return $grid;
}


