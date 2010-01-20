#! /usr/bin/perl
# Sums all the numbers in input
# (c) LGPL 2010 - Steve Schnepp

my $value;

while (<>) {
	$value += $_;
}

print $value . "\n";
