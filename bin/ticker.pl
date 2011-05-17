#! /usr/bin/perl
# Burns CPU, to see if all the processes are well balanced & if there is some CPU steal (on VMs)

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
