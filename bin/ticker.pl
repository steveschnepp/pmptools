#! /usr/bin/perl
# Burns CPU, to see if 
# - the timeslices are well balanced on all the processes
# - there is some CPU steal (for VMs guests)
# - the number of virtual processors has a performance influence

use strict;
use warnings;

my $nb_processes = shift || 1;

for my $i (1 .. $nb_processes) {
        next if fork();

	my $counter = 1;

	$SIG{ALRM} = sub {
		print "$$: $counter\n";
		$counter = 1;
		alarm(1);
	};

	alarm(1);

        $0 .= " [$i/$nb_processes]";

	my $computation = 1;
	while ($counter ++) { $computation += $computation * 7 + $computation >> 33; }
}

# Waiting for childs
while (wait()) { }
