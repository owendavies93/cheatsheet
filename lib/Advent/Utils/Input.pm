package Advent::Utils::Input;

use Mojo::Base 'Exporter';

our @EXPORT_OK = qw(
    get_grouped_lines
    get_ints
    get_lines
    get_nonempty_groups
    split_line
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

sub split_line {
    my ($line, $num_parts) = @_;

    my $len = length $line;
    my $part_len = int(0.5 + ($len / $num_parts));
    my $part = 0;
    my @parts;
    my @s = split //, $line;
    while ($part < $num_parts) {
        my $start = $part * $part_len;
        my $end = ($part + 1) * $part_len - 1;

        if ($end >= $len) {
            $end-- while $end >= $len;
        }

        push @parts, join '', @s[$start..$end];
        $part++;
    }
    return @parts;
}

1;
