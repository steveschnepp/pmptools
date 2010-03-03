#! /usr/bin/perl
# like head or tail, but between two regex
# (c) 2010 - Steve Schnepp

use strict;
use warnings;

my $start = shift;
my $stop = shift;

my $is_between = 0;
while (my $line = <>) {
       if (! $is_between && $line =~ m/$start/) {
               $is_between++;
       }

       if ($is_between && $line =~ m/$stop/) {
               $is_between++;
       }

       if ($is_between == 1) {
               print $line;
       }
}
