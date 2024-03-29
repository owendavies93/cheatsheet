package Advent::Dijkstra;

use Mojo::Base -strict;

use Array::Heap::PriorityQueue::Numeric;
use Carp;
use List::Util qw(sum);

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    return $self;
}

# Get the list of nodes in the shortest path start to end
sub get_shortest_path {
    my ($self, $opts) = @_;

    my $path = $self->_generate_shortest_path($opts);
    my @nodes = reverse map { $_->{node} } @$path;
    return @nodes;
}

# Gets the number of steps in the shortest path, not including
# the start node. i.e. if there's no path, the length wil be 
# zero, nohortest_path one
sub get_shortest_path_length {
    my ($self, $opts) = @_;

    return scalar $self->get_shortest_path($opts);
}

# Get the sum of the weights for the shortest path
sub get_total_path_weight {
    my ($self, $opts) = @_;

    my $path = $self->_generate_shortest_path($opts);
    return sum map { $_->{weight} } @$path;
}

# edge_list is a nested hash, with weights:
# 'x' => {
#   'a' => '9',
#   'b' => '9',
#   'c' => '6',
#   'd' => '3'
# },
# assumes there is a valid path from start to end
# 
# end_func is a function that specifies if we're at the
# end and should return the path. end_func will be
# ignored if end is supplied
#
# set regen to overwrite any caching
# returns a path of the form:
# [
#   { node => 'x', weight => '9' },
#   { node => 'a', weight => '2' },
#   ...
# ]
sub _generate_shortest_path {
    my ($self, $opts) = @_;
    
    for (qw(start edge_list)) {
        croak "Need $_ option" unless defined $opts->{$_};
    }

    if (!defined $opts->{end} && !defined $opts->{end_func}) {
        croak "Need end or end_func options";
    }

    if (defined $self->{path} && !defined $opts->{regen}) {
        return $self->{path};
    }

    if (!defined $opts->{end_func} || defined $opts->{end}) {
        $opts->{end_func} = sub {
            my ($c, $opts) = @_;
            return $c eq $opts->{end};
        }
    }
    
    my $start = $opts->{start};
    my $e = $opts->{edge_list};

    my $dist = {};
    my $prev = {};
    my $q = Array::Heap::PriorityQueue::Numeric->new;
    my $path = [];

    $dist->{$start} = 0;
    $q->add($start, 0);

    while (1) {
        my $c = $q->get();

        if (!defined $c) {
            return [];
        }

        if ($opts->{end_func}->($c, $opts)) {
            while ($c ne $start) {
                my $p = $prev->{$c};
                push @$path, {
                    node   => $p,
                    weight => $e->{$p}->{$c},
                };
                $c = $p;
            }
            $self->{path} = $path;
            return $path;
        }

        for my $n (keys %{$e->{$c}}) {
            my $new_dist = $dist->{$c} + $e->{$c}->{$n};
            if (!defined $dist->{$n} || $new_dist < $dist->{$c}) {
                $dist->{$n} = $new_dist;
                $q->add($n, $new_dist);
                $prev->{$n} = $c;
            }
        }
    }
}

1;
