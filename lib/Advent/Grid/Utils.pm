package Advent::Grid::Utils;

use Mojo::Base 'Exporter';

our @EXPORT_OK = qw(
    get_grid
    d4
    d8
    d_diag
);

sub get_grid {
    my ($fh) = @_;
    my @grid;
    my $width = 0;
    my $height = 0;
    while (<$fh>) {
        chomp;
        push @grid, split //;
        $width = @grid if $width == 0;
        $height++;
    }
    return (\@grid, $width, $height);
}

sub d4 {
    return ( [-1, 0], [1, 0], [0, -1], [0, 1] );
}

sub d8 {
    return ( [-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1] );
}

sub d_diag {
    return ( [-1, -1], [-1, 1], [1, -1], [1, 1] );
}

1;
