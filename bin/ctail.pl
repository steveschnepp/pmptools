#! /usr/bin/perl
# Poor man's ctail(1) in Perl
# (C) 2007 Steve Schnepp - LGPL

use strict;
use warnings;
use Carp;
use Data::Dumper;

use IO::File;
use Getopt::Long;

my $help;
my $verbose;

my $result = GetOptions(
        "help|h" => \$help,
        "verbose|v" => \$verbose,
);

if ($help) {
        print STDERR "Perl loose port of ctail(1) from http://ctail.i-want-a-pony.com/\n";
        print STDERR "usage : $0 [host:]filename .. [host:]filename\n";
        exit(1);
}

my $files = {};
foreach my $arg (@ARGV) {
	my $cmd;
	if ($arg =~ m/(.+):(.+)/) {
		# It's an "ssh" file
		$cmd = "ssh $1 tail -f $2";
	} else {
		# Regular file, just use a plain tail
		$cmd = "tail -f $arg";
	}

	my $file = new IO::File("$cmd |");
	$files->{$arg} = $file;

	# Use non blocking IO, to be able to follow many streams at once
	$file->blocking(0);
}

if ((scalar keys %$files) <= 0) {
	# No file to follow
	exit 0;
}

# listen to it
my $current_file = ""; # Avoid undef. Empty filenames should not happen anyway.
for (;;) {
	my $is_updated;
	while (my ($filename, $file) = each %$files) {
		my $line = $file->getline();
		if (defined($line) && $line ne "") {
			if ($current_file ne $filename) {
				# Changed file
				print "==> $filename <==\n";
				$current_file = $filename
			}
			
			print $line;
			$is_updated ++;
		}
	}
	
	if (! $is_updated) {
		# Be CPU-friendly if nothing happened
		sleep(1);
	}
}

__END__
