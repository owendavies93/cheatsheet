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

`List::AllUtils` has nearly everything you ever need:
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

The only thing that I ever use in `List::MoreUtils` is `natatime`:

```
@arr = (1, 2, 3, 4);
$n = 2;
$it = natatime $n, @arr;
while (my @group = $it->()) { ... }
```

`List::Flatten` has `flat` which turns a 2D list into a 1D list.

`Algorithm::Combinatorics` has `permutations` and `combinations`.

### Data Structures
TODO

### Common Algorithms
TODO
