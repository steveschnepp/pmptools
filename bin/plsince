#! /usr/bin/perl
# Perl port of since(1) from http://welz.org.za/projects/since
# LGPL (c) 2008 Steve Schnepp <steve.schnepp@pwkf.org> 

use strict;
use warnings;
use Carp;
use Data::Dumper;
	
use Fcntl 'SEEK_CUR';

use NDBM_File;
my %since;
tie(%since, 'NDBM_File', '~/.plsince', 1, 0);

my $filename = shift;

my $buffer;

my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size, $atime,$mtime,$ctime,$blksize,$blocks) = stat($filename);

my $since_key = "$dev/$ino";

open (FILE, $filename);
my $count = $since{$since_key};
if ($count) {
	sysseek(FILE, $count, SEEK_CUR);
}

while ((my $read_count = sysread (FILE, $buffer, 4096)) > 0) {
	$count += $read_count;
	print STDERR "read_count:$read_count, count:$count\n";
}

$since{$since_key} = $count;
