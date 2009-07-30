#! /usr/bin/perl
# Poor man's ctail(1) in Perl
# (C) 2007 Steve Schnepp - LGPL

use strict;
use warnings;
use Carp;
use Data::Dumper;

use IO::File;

my $isFollowing = 0;

# Q&D Gestion des arguments
while (my $arg = shift @ARGV) {
	if ($arg !~ m/^\-/) {
		# Fin des arguments, on remet dans la file
		unshift @ARGV, $arg;
		last;
	}
	
	if ($arg eq "-f") {
		$isFollowing = 1;
	}
}

# Construct the array to "listen" to 
my $files = {};
foreach my $arg (@ARGV) {
	my $cmd;
	if ($arg =~ m/(.+):(.+)/) {
		# It's  a ssh file
		$cmd = "ssh $1 tail -f $2";
	} else {
		$cmd = "tail -f $arg";
	}

	my $file = new IO::File("$cmd |");
	$file->blocking(0);
	$files->{$arg} = $file;
}

if ((scalar %$files) <= 0) {
	exit;
}

# listen to it
my $current_file;
for (;;) {
	my $isupdated = 0;
	while (my ($filename, $file) = each %$files) {
		my $line = $file->getline();
		if (defined($line) && $line ne "") {
			if ($current_file ne $filename) {
				print "==> $filename <==\n";
				$current_file = $filename
			}
			
			print $line;
			$isupdated = 1;
		}
	}
	
	if (! $isupdated) {
		sleep(1);
	}
}

__END__
