#! /usr/bin/perl
# Throttle CPU usage for a process.
# 
# Idea borrowed from blabla999 on the SO question : 
# http://stackoverflow.com/questions/386945/limiting-certain-processes-to-cpu-linux
#
# (c) 2010 - Apache-2.0 - Steve Schnepp <steve.schnepp@pwkf.org>

# The usual stuff
use strict;
use warnings;

# Be able to have fractional second sleeps
use Time::HiRes qw(sleep);

# Avoid having a timing information
die "You have to specify a timing & a command" unless (scalar @ARGV);

# Reading cpu percentage
my $cpu_percent = shift;

if ($cpu_percent > 100) {
	die "You cannot allocate more that 100% CPU";
}

# Do it on a 10Hz base
my $frequency_hz = 10; 

# Compute the DUTY/OFF DUTY cycle timings
my $off_duty_sec = (1 - $cpu_percent / 100) / $frequency_hz;
my $on_duty_sec = ($cpu_percent / 100) / $frequency_hz;

# The PID to throttle. 
# Copy it since the array will be shrinked when needed
my @pids_to_throttle = @ARGV;

# Do it until nothing to throttle anymore
while (scalar @pids_to_throttle) {
	# Stop all the designated processes
	foreach my $pid (@pids_to_throttle) {
		kill STOP => $pid;
	}

	# OFF DUTY cycle
	sleep($off_duty_sec);

	# Restart all the designated processes
	foreach my $pid (@pids_to_throttle) {
		kill CONT => $pid;
	}
	
	# DUTY cycle
	sleep($on_duty_sec);
}
