#! /usr/bin/perl
# replacement of uniq(1) that doesn't need a sort
# (c) LGPL 2017 - Steve Schnepp

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
