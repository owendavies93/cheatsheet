#!/usr/bin/env perl

use Mojo::Base -strict;

use Test::More;

use_ok 'Advent::Utils::Input';
require_ok 'Advent::Utils::Input';

use Advent::Utils::Input qw(get_ints);

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

done_testing();

