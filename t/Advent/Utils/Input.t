#!/usr/bin/env perl

use Mojo::Base -strict;

use Test::More;

use_ok 'Advent::Utils::Input';
require_ok 'Advent::Utils::Input';

use Advent::Utils::Input qw(
    get_grouped_lines
    get_ints
    get_lines
    get_nonempty_groups
    split_line
);

# get_ints
{
    my $line = 'asfsdkaf12jghgk12';
    is_deeply( [ get_ints($line) ], [ (12, 12) ] ); 

    $line = 'asdsadasda-12sadasdad-11';
    is_deeply( [ get_ints($line, 1) ], [ (-12, -11) ] ); 

    $line = 'asdsadasda-12sadasdad-11';
    is_deeply( [ get_ints($line) ], [ (12, 11) ] ); 

    $line = 'move 1 from 2 to 1';
    is_deeply( [ get_ints($line, 1) ], [ (1, 2, 1) ] ); 

    $line = '[Z] [M] [P]';
    is_deeply( [ get_ints($line, 1) ], [] );

    $line = '2-4,6-8';
    is_deeply( [ get_ints($line) ], [ (2, 4, 6, 8) ] );

    $line = '2-4,6-8';
    is_deeply( [ get_ints($line, 1) ], [ (2, -4, 6, -8) ] );
}

# get_grouped_lines
{
    my $file = 't/data/test_get_grouped_lines';
    open(my $fh, '<', $file) or die $!;

    my @groups = get_grouped_lines($fh, 3);

    cmp_ok( scalar @groups, '==', 4 );

    my $g = $groups[-1];

    cmp_ok( scalar @$g, '==', 1 );
    cmp_ok( $g->[0], '==', 10000 );
}

# get_lines
{
    my $file = 't/data/test_get_lines';
    open(my $fh, '<', $file) or die $!;

    my @lines = get_lines($fh);

    cmp_ok( scalar @lines, '==', 14 );
}

# get_nonempty_groups
{
    my $file = 't/data/test_get_lines';
    open(my $fh, '<', $file) or die $!;

    my @groups = get_nonempty_groups($fh);

    cmp_ok( scalar @groups, '==', 5 );

    my $g = $groups[0];

    cmp_ok( scalar @$g, '==', 3 );
    cmp_ok( $g->[0], '==', 1000 );

    $g = $groups[-1];

    cmp_ok( scalar @$g, '==', 1 );
    cmp_ok( $g->[0], '==', 10000 );
}

# split_line 
{
    my $line = "12345678";

    my @split = split_line($line, 2);

    cmp_ok( scalar @split, '==', 2 );
    cmp_ok( $split[0], 'eq', '1234' );
    cmp_ok( $split[1], 'eq', '5678' );

    @split = split_line($line, 3);

    cmp_ok( scalar @split, '==', 3 );
    cmp_ok( $split[0], 'eq', '123' );
    cmp_ok( $split[1], 'eq', '456' );
    cmp_ok( $split[2], 'eq', '78' );
}

done_testing();

