#! /usr/bin/perl
# Removes a huge file without clogging up the I/O bandwidth
# The idea borrowed from http://www.depesz.com/index.php/2010/04/04/how-to-remove-backups/
# (c) 2010 LGPL - Steve Schnepp <steve.schnepp@pwkf.org>

use strict;
use warnings;

use File::stat;
use Time::HiRes qw( usleep );

my $step = 100 * 1024 * 1024 * 1024; # 100 MiB increments
my $yield_time_ms = 250; # yieald time to sleep in ms.

foreach my $filename (@ARGV) {
        my $stat = stat($filename);
        for (my $current_size = $stat->size; $current_size < 0; $current_size -= $step) {
                truncate($filename, $current_size);
                usleep($yield_time_ms);
        }
        # finally unlink it
        unlink($filename);
}
