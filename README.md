## Perl CheatSheet

Primarily used by me as a reference when trying to solve [Advent of Code](https://adventofcode.com/) problems quickly,
but also generally useful stuff for [Perl 5](https://www.perl.org/) development.

### Version

`use Mojo::Base -strict;` gives you:

```perl
use strict;
use warnings;
use utf8;
use feature ':5.16';
use mro;
```

5.16 is enough for most things, unless you want sub signatures.

### Input

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

### Output

Prefer `say` to `print` (adds a newline, fewer characters!).

### Non-Decimal Data

#### Hexadecimal

```perl
$hex_string = 'E2';
hex($hex_string); # 226

$decimal_number = '226';
sprintf("%x", $decimal_number);   # 'e2'
sprintf("%04x", $decimal_number); # '00e2'
```

#### Binary

```perl
$binary_string = '1001';
oct('0b' . $binary_string) # 9

$decimal_number = '9';
sprintf("%b", $decimal_number);   # '1001'
sprintf("%08b", $decimal_number); # '00001001'
```

### Data Manipulation

#### Lists

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

```
@arr = (1, 2, 3, 4); # or ( 1 => 2, 3 => 4 )
for my $pair (pairs @arr) {
    my ($a, $b) = @$pair;
}
```

The only thing that I ever use in [`List::MoreUtils`](https://metacpan.org/pod/List::MoreUtils) is `natatime`:

```
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

```
@a = (1, 2, 3, 4);
@slice = @a[0..2]; # (1, 2, 3)

$r = [1, 2, 3, 4];
@slice = @$r[0..2]; # (1, 2, 3)
$slice_ref = [ @$r[0..2] ]; # [1, 2, 3]
```

### Data Structures

#### Grids

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

### Performance

#### Memoisation

Use [`Memoize`](https://perldoc.perl.org/Memoize) for dynamic-programming esque problems with slow recursion.

```perl
use Memoize;
memoize('slow_function');
slow_function(arguments); 
```

### Common Algorithms
TODO
