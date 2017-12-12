#! /usr/bin/perl
# replacement of uniq(1) that doesn't need a sort
# (c) 2017 - Apache-2.0 - Steve Schnepp <steve.schnepp@pwkf.org>

my %h;

# Slurping
while (my $line = <>) {
	$h{$line} ++;
}

# Emitting
keys %h; # reset the internal iterator
while(my($k, $v) = each %h) {
	printf "%6d %s", $v, $k;
}
