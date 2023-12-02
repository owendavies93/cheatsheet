package Advent::Utils::Problem;

use Mojo::Base 'Exporter';

use FindBin;
use Term::ANSIColor qw(:constants colored);
use Time::HiRes qw(time);

our @EXPORT_OK = qw(
	run_part
	submit_part
);

sub _display_aoc_response {
	my $res = shift;

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
	my ($year, $day, $part) = @_; 

	my $path = _find_year($FindBin::Bin, "advent$year");

	my $t = time;
	my $out = `perl $path/bin/day$day-$part.pl`;
	my $t2 = time;
	print WHITE "Part $part answer: ";
	print GREEN $out;

	my $diff = int(($t2 - $t) * 1000);
	print WHITE 'Runtime: ';
	print GREEN "$diff ms\n";

	return $out;
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

	print WHITE "Submitting ";
	say GREEN $answer;

	my $res = `aoc submit -q -d $day $part $answer`;
	say RESET "Response from AOC:";
	_display_aoc_response($res);
}

1;

