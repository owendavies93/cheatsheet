package Advent::Utils::Input;

use Mojo::Base 'Exporter';

our @EXPORT_OK = qw(
    get_grouped_lines
    get_ints
    get_lines
    get_nonempty_groups
);

sub get_grouped_lines {
    my ($fh, $group_size) = @_;
    my @groups;
    my $curr = [];
    my $curr_size = 0;
    while (<$fh>) {
        chomp;
        if ($curr_size == $group_size) {
            push @groups, $curr;
            $curr = [];
            $curr_size = 0;
        }
        push @$curr, $_;
        $curr_size++;
    }
    push @groups, $curr;
    return @groups;
}

sub get_ints {
    my ($line, $negative) = @_;

    if (defined $negative) {
        return $line =~ /(-?\d+)/g;
    } else {
        return $line =~ /(\d+)/g;
    }
}

sub get_lines {
    my $fh = shift;
    my @lines;
    while (<$fh>) {
        chomp;
        push @lines, $_;
    }
    return @lines;
}

sub get_nonempty_groups {
    my $fh = shift;
    my @groups;
    my $curr = [];

    while (<$fh>) {
        chomp;
        if (!$_) {
            push @groups, $curr;
            $curr = [];
            next;
        }

        push @$curr, $_;
    }
    push @groups, $curr;
    return @groups;
}

1;
