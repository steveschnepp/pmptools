#! /usr/bin/perl
# Avoid crontab-induced load spikes by introducing random delays
# 
# Idea borrowed from Bjørn Hansen 
# http://www.askbjoernhansen.com/2007/11/19/space_out_cronjobs.html
#
# (c) 2010 - Apache-2.0 - Steve Schnepp <steve.schnepp@pwkf.org>

# The usual stuff
use strict;
use warnings;

# Be able to have fractional second sleeps
use Time::HiRes qw(sleep);

# Avoid having a timing information
die "You have to specify a timing & a command" unless (scalar @ARGV);

# Reading timing
my $time_human = shift;

# Dictionary to convert units to seconds
my $duration_in_sec = {
	s => 1,
	m => 60,
	h => 60 * 60,
	d => 24 * 60 * 60,
};

my $time_sec;
if ($time_human =~ m/^([0-9.]+)([smhd])$/) {
	# Convert the human-readable duration into 
	# its second counterpart
	$time_sec = $1 * $duration_in_sec->{$2};
} else {
	# Cannot read it. Take the numeric part 
	# and assume it's seconds.
	$time_sec = 0 + $time_human;
}

# Now sleep some random time, up to $time_sec seconds
sleep( rand($time_sec) );

# Nothing to exec, exit
exit unless scalar @ARGV;

# Asked to execute something after sleeping. 
exec @ARGV;
