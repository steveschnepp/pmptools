#! /usr/bin/perl
# Sums all the numbers in input
# (c) 2010 - Apache-2.0 - Steve Schnepp <steve.schnepp@pwkf.org>

my $value;

while (<>) {
	$value += $_;
}

print $value . "\n";
