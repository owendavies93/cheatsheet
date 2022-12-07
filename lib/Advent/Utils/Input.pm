package Advent::Utils::Input;

use Mojo::Base 'Exporter';

our @EXPORT_OK = qw(get_ints);

sub get_ints {
    my ($line, $negative) = @_;

    if (defined $negative) {
        return $line =~ /(-?\d+)/g;
    } else {
        return $line =~ /(\d+)/g;
    }
}

1;
