Primarily used by me as a reference when trying to solve [Advent of Code](https://adventofcode.com/) problems quickly,
but also generally useful stuff for [Perl 5](https://www.perl.org/) development.

## Table of Contents
  * [Version](#version)
  * [Input](#input)
  * [Output](#output)
  * [Non-Decimal Data](#non-decimal-data)
    + [Hexadecimal](#hexadecimal)
    + [Binary](#binary)
  * [Strings](#strings)
    + [Characters](#characters)
  * [Data Manipulation](#data-manipulation)
    + [Lists](#lists)
      - [Slices](#slices)
      - [Sorting](#sorting)
  * [Data Structures](#data-structures)
    + [Grids](#grids)
  * [Performance](#performance)
    + [Memoisation](#memoisation)
  * [Common Algorithms](#common-algorithms)

## Version

`use Mojo::Base -strict;` gives you:

```perl
use strict;
use warnings;
use utf8;
use feature ':5.16';
use mro;
```

5.16 is enough for most things, unless you want sub signatures.

## Input

Read STDIN line by line:

```perl
while (<>) {
    chomp;
    next if !$_; # skips a blank line
}
```

Read a single line of input from STDIN:

```perl
my $line = scalar(<>);
chomp($line);
```

Read from a file handle:

```perl
my $file = "input";
open(my $fh, '<', $file) or die $!;
while (<$fh>) { ... }
```

## Output

Prefer `say` to `print` (adds a newline, fewer characters!).

## Non-Decimal Data

### Hexadecimal

```perl
$hex_string = 'E2';
hex($hex_string); # 226

$decimal_number = '226';
sprintf("%x", $decimal_number);   # 'e2'
sprintf("%04x", $decimal_number); # '00e2'
```

### Binary

```perl
$binary_string = '1001';
oct('0b' . $binary_string) # 9

$decimal_number = '9';
sprintf("%b", $decimal_number);   # '1001'
sprintf("%08b", $decimal_number); # '00001001'
```

## Strings

`substr $string $offset $length` does substrings, omit the last argument to go to the end.
Minus arguments go back from the end of the string.

### Characters

Use `ord` and `chr` to go between characters and ascii codes:

```perl
ord('a') # 97
chr(97) # 'a'
```

**Remember**: use `>` and `<` for `ord` and use `lt` and `gt` for `chr`:

```perl
chr(97) gt 'Z' # true, 'a' gt 'Z'
chr(97) > 'Z'  # undef, and warns

97 <= ord('d') # true, 97 <= 100
97 le ord('d') # undef, no warnings
```

## Data Manipulation

### Parsing complex data

In Advent of Code problems, it's probably safe to use `eval` to parse these sorts of inputs:

```perl
$input = '[1,[2,[3,[4,[5,6,7]]]],8,9]';
$out = eval $input; # out is a nested data structure
ref($out) # ARRAY
```

### Lists

[`List::AllUtils`](https://metacpan.org/pod/List::AllUtils) has nearly everything you ever need:
- `any`
- `all`
- `first`
- `max`
- `min`
- `sum`
- `product`
- `pairs`

These are all obvious, perhaps apart from `pairs`:

```perl
@arr = (1, 2, 3, 4); # or ( 1 => 2, 3 => 4 )
for my $pair (pairs @arr) {
    my ($a, $b) = @$pair;
}
```

The only thing that I ever use in [`List::MoreUtils`](https://metacpan.org/pod/List::MoreUtils) is `natatime`:

```perl
@arr = (1, 2, 3, 4);
$n = 2;
$it = natatime $n, @arr;
while (my @group = $it->()) { ... }
```

[`Array::Utils`](https://metacpan.org/pod/Array::Utils) has useful set operations:
- `intersect` - intersection
- `unique` - this is unique union
- `array_diff` - symmetric difference
- `array_minus(@a, @b)` - keep things that are in `@a` but not in `@b`

[`List::Flatten`](https://metacpan.org/pod/List::Flatten) has `flat` which turns a 2D list into a 1D list.

[`Algorithm::Combinatorics`](https://metacpan.org/pod/Algorithm::Combinatorics) has `permutations` and `combinations`. Returns an iterator in scalar context, and all results in list context (prefer scalar context if you need to do something with each result, it's quicker).

#### Slices

Get a subsection of a list.

```perl
@a = (1, 2, 3, 4);
@slice = @a[0..2]; # (1, 2, 3)

$r = [1, 2, 3, 4];
@slice = @$r[0..2]; # (1, 2, 3)
$slice_ref = [ @$r[0..2] ]; # [1, 2, 3]
```

#### Sorting

Slices are often useful combined with `sort`, for "top n"-type operations:

```perl
@a = (3, 2, 4, 1);
@sorted = sort { $b <=> $a } @a;
@top3 = @sorted[0..2];
```

## Data Structures

### Grids

If it's dense, use a 1D array:

```perl
@grid = ();
while (<>) {
    chomp;
    my @line = split //;
    push @grid, @line;
}

$val = $grid[$y * $width + $x];
```

See [2021 Day 11](https://github.com/sirgraystar/advent2021/blob/main/bin/day11-1.pl) for a larger example.

There's a generic implementation of this in [Advent::Grid::Dense](https://github.com/sirgraystar/cheatsheet/blob/main/lib/Advent/Grid/Dense.pm), for both diagonal and non-diagonal neighbours.

If it's sparse and binary, use a hash to set coordinates.

```perl
$grid = {};
$grid->{$x, $y} = 1; # $; is the key separator
$val = $grid->{$x, $y};

for my $k (keys %$grid) {
    my ($x, $y) = split $;, $k;
}
```

See [2021 Day 25](https://github.com/sirgraystar/advent2021/blob/main/bin/day25.pl) for a sparse ternary example.

There's a generic implementation of this in [Advent::Grid::Sparse](https://github.com/sirgraystar/cheatsheet/blob/main/lib/Advent/Grid/Sparse.pm).Often it won't be suitable due to problems requiring generic manipulation of values within the grid, but it works for Cellula Automata type problems and problems where you simply need to track a set of points.

### Queues

Normal perl lists work well as simple queues.

```perl
my @q = (1,2,3);
while (@q) { # scalar @q == 0
    my $head = shift @q;
    if (...) {
        my $new = 4;
        push @q, $new;
    }
}
```

For a priority queue, use Array::Heap::PriorityQueue::Numeric - it's the fastest one I've found.

```perl
my $q = Array::Heap::PriorityQueue::Numeric->new;
$q->add(1, 100);
while ($q->size()) {
    my $head = $q->get();
    if (...) {
        $q->add(2, 1); # will be at the head
    }
}
```

## Performance

### Memoisation

Use [`Memoize`](https://perldoc.perl.org/Memoize) for dynamic-programming esque problems with slow recursion.

```perl
use Memoize;
memoize('slow_function');
slow_function(arguments); 
```

## Common Algorithms

### Dijkstra

[Advent::Dijkstra](https://github.com/sirgraystar/cheatsheet/blob/main/lib/Advent/Dijkstra.pm) implements the shortest path algorithm, and supports path length and total path weight.

```perl
# opts takes the following options:
# * start - the start node label
# * end - the end node label
# * edge_list - a nested hash, as outputted by Advent::Grid::Dense::edge_list()
# * regen - don't do any caching
my $d = Advent::Dijkstra->new;
$d->get_shortest_path($opts);
$d->get_shortest_path_length($opts);
$d->get_total_path_weight($opts);
```

### BFS

Something like this works well for BFS shortest path between two nodes. Usually
the trick is to implement and problem specific logic in the adjacency check.

```perl
sub bfs {
    my ($start, $end) = @_;
    my @q;
    my $seen;
    my $st = {};
    push @q, $start;
    $seen->{$start} = 1;

    while (@q) {
        my $c = shift @queue;
        my $adjs = get_adjs($c); # Implement this
        for my $adj (@$adjs) {
            next if $seen->{$adj};
            $st->{$adj}->{prev} = $c;
            if ($adj eq $end) {
                my @path;
                push @path, $end;
                my $prev = $st->{$end}->{prev};
                while (1) {
                    if ($prev eq $start) {
                        push @path, $start;
                        last;
                    }
                    push @path, $prev;
                    $prev = $st->{$prev}->{prev};
                }
                return reverse @path;
            }
            else {
                push @queue, $adj;
            }
            $seen->{$adj} = 1;
        }
    }
    die "No path";
}
```

### DFS

Same thing but DFS. Useful when the graph might have dead ends, or if we want
the longest path (rare, but came up in 2023).

```perl
my $seen = {};
my $end = # TODO;
sub dfs {
    my $cur = shift;
    return 0 if $cur eq $end;

    $seen->{$cur} = 1;
    my $max_path;
    my $adjs = get_adjs($cur);
    for my $adj (@$adjs) {
        next if $seen->{$adj};
        my $sub = dfs($adj);
        next unless defined $sub; # If there's no path found in the recursive case
        # Add on the current distance, or the weight if there is one
        $sub++;
        # my $dist = get_dist($cur, $adj);
        # $sub += $dist;
        $max_path = $sub if !defined $max_path || $sub > $max_path;
    }

    delete $seen->{$cur};
    return $max_path;
}
```
