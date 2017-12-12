#! /usr/bin/perl
# Replacement for mktemp(1) 
# (c) 2012 - Apache-2.0 - Steve Schnepp <steve.schnepp@pwkf.org>

use Getopt::Long;
use File::Temp qw/ tempdir /;

my $directory;
GetOptions(
        'directory|d' => \$directory,
) or usage();

my $template = shift;
if ($directory) {
        print File::Temp::tempdir($template);
} else {
        print File::Temp->new(TEMPLATE => $template, UNLINK => 0,);
}
print "\n";

sub usage {
        print "mktemp [-d] <template>\n";
        exit 1;
}

