#! /usr/bin/perl
# Burns CPU, to see if 
# - the timeslices are well balanced on all the processes
# - there is some CPU steal (for VMs guests)
# - the number of virtual processors has a performance influence

use strict;
use warnings;

# No buffer, since we want to be able to pipe
$| = 1;

my $nb_processes = shift; if (! defined $nb_processes) { $nb_processes = 1; };
my $nb_iter = shift || 0;

for my $i (1 .. $nb_processes) {
        next if fork();
	compute($i);
}

compute(0) unless $nb_processes;

sub compute {
	my ($i) = @_;

	my $counter = 1;
	my $counter_iter = 1;

	$SIG{ALRM} = sub {
		print "$$: $counter\n";
		$counter = 1;
		$counter_iter ++;
		if ($nb_iter && $counter_iter > $nb_iter) { exit(1); };
		alarm(1);
	};

	alarm(1);

        $0 .= " [$i/$nb_processes]";

	my $computation = 1;
	while ($counter ++) { $computation += $computation * 7 + $computation >> 33; }
}

END {
	# Kill the process group
	kill (-1 * $$);
};

# Waiting for childs
while (wait() != -1) { }
