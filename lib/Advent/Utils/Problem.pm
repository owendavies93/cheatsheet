package Advent::Utils::Problem;

use Mojo::Base 'Exporter';

use Cwd;
use FindBin;
use IPC::Run qw(run timeout);
use Term::ANSIColor qw(:constants colored);
use Time::HiRes qw(time);

our @EXPORT_OK = qw(
    run_part
    submit
    submit_part
);

sub _display_aoc_response {
    my $res = shift;

    $res =~ s/\R//g;

      my $known_responses = {
          "You don't seem"     => 'red',
          "That's the correct" => 'green',
          "That's not"         => 'red',
      };

    my $printed = 0;
    for my $c (keys %$known_responses) {
        if ($res =~ $c) {
            say colored($res, $known_responses->{$c});
            $printed = 1;
            last;
        }
    }
    say $res if $printed == 0;
}

sub _find_year {
    my ($path, $dir) = @_;

    if (-d "$path/$dir") {
        return "$path/$dir";
    } else {
        return _find_year("$path/..", $dir);
    }
}

sub run_part {
    my ($year, $day, $part, $timeout) = @_;

    my $path = _find_year($FindBin::Bin, "advent$year");

    my $t = time;
    my $out;
    eval {
        run ['perl', "$path/bin/day$day-$part.pl"], \undef, \$out, timeout($timeout);
    };
    if ($@) {
        die $@ if $@ !~ /^IPC::Run: timeout/;
        say RED "Runtime over $timeout seconds, aborting.";
        return ("", -1);
    } else {
        my $t2 = time;
        print WHITE "Part $part answer: ";
        print GREEN $out;

        my $diff = int(($t2 - $t) * 1000);
        print WHITE 'Runtime: ';
        print GREEN "$diff ms\n";

        return ($out, $diff);
    }
}

# Assumes standard filename formats and dir structures
# Only use this for submitting the problem currently
# being worked on
sub submit {
    my $answer = shift;
    my ($year) = cwd =~ /advent(\d+)$/;
    my ($day, $part) = $0 =~ /day(\d+)-(\d)/;
    say WHITE "Submitting $year day $day part $part";
    _submit($year, $day, $part, $answer);
    exit;
}

sub submit_part {
    my ($year, $day, $part, $answer) = @_;
    ASK:
    say RESET "Do you want to submit this answer? [Y/n]";
    my $yes = <STDIN>;
    chomp $yes;

    if ($yes =~ /^[Nn]$/) {
        warn "Not submitting part $part.\n";
        return;
    } elsif ($yes ne '' && $yes !~ /^[Yy]$/) {
        warn "Please provide y or n.\n";
        goto ASK;
    }

    _submit($year, $day, $part, $answer);
}

sub _submit {
    my ($year, $day, $part, $answer) = @_;
    print WHITE "Submitting ";
    say GREEN $answer;
    my $res = `aoc submit -q -d $day $part $answer`;
    say RESET "Response from AOC:";
    _display_aoc_response($res);
}

1;

