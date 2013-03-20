#! /usr/bin/perl
# like head or tail, but between two regex
# (c) 2010 - Steve Schnepp

use strict;
use warnings;

my $start = shift;
my $stop = shift;

my $is_between = 0;
while (my $line = <>) {
       # Note that the flip-flop (..) is not use on purpose as it only 
       # switches properly if both states are mutally exclusive
       # 
       # see : http://perldoc.perl.org/perlop.html#Range-Operators
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
