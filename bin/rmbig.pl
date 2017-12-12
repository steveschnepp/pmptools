#! /usr/bin/perl
# Removes a huge file without clogging up the I/O bandwidth
# Idea borrowed from http://www.depesz.com/index.php/2010/04/04/how-to-remove-backups/
# (c) 2010 - Apache-2.0 - Steve Schnepp <steve.schnepp@pwkf.org>

# TODO - Should implement these flags : 
# rm generic flags : 
#  -f, --force           ignore nonexistent files, never prompt
#  -v, --verbose         explain what is being done
#  -r, -R, --recursive   remove directories and their contents recursively
#  --help      
#  --version   

# rmbig specific flags : 
#  -s, --step-size       Use this step size [ default: 100MiB ] 
#  -y, --yield-time      Yield time in ms [ default: 250ms ]

use strict;
use warnings;

use File::stat;
use Time::HiRes qw( usleep );

my $step = 100 * 1024 * 1024 * 1024; # 100 MiB increments
my $yield_time_ms = 250; # yieald time to sleep in ms.
my $verbose = 1; 

foreach my $filename (@ARGV) {
        print "removing $filename\n" if $verbose;

        # truncate progressively to less than the smallest step
        my $stat = stat($filename) or die($!);
        for (my $current_size = $stat->size - $step; $current_size > 0; $current_size -= $step) {
                truncate($filename, $current_size) or die($!);
                usleep($yield_time_ms);
        }

        # finally unlink it
        unlink($filename);
}
