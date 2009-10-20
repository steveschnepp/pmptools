#! /usr/bin/perl
# Perl port of since(1) from http://welz.org.za/projects/since
# LGPL (c) 2008 Steve Schnepp <steve.schnepp@pwkf.org> 

use strict;
use warnings;
use Carp;
use Data::Dumper;

use Fcntl qw/SEEK_SET O_RDWR O_CREAT/;
use Getopt::Long;

my $db_filename = "$ENV{HOME}/.psince";
my $help;
my $verbose;
my $result = GetOptions(
	"db-filename|f=s" => \$db_filename, 
	"help|h" => \$help, 
	"verbose|v" => \$verbose, 
);

if ($help) {
	print STDERR "Perl port of since(1) from http://welz.org.za/projects/since\n";
	print STDERR "usage : $0 [-f db-filename (default ~/.plsince)] filename\n";
	exit(1);
}

use NDBM_File;
my %states;

print STDERR "db_filename: $db_filename\n" if $verbose;
tie(%states, 'NDBM_File', $db_filename, O_CREAT | O_RDWR, 0660)
	or die("cannot tie state to $db_filename : $!");

while (my $filename = shift ) {
	if (! -r $filename) {
		# Cannot read, ignore
		next;
	}
	print STDERR "filename: $filename\n" if $verbose;


	my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size, $atime,$mtime,$ctime,$blksize,$blocks) = stat($filename);
	if (! defined $dev) {
		print STDERR "Cannot stat file $filename: $!\n";
		exit(2);
	}

	my $state_key = "$dev/$ino";
	print STDERR "since_key: $state_key\n" if $verbose;


	if (! open (FILE, $filename)) {
        	print STDERR "cannot open $filename : $!";
	        next;
	}

	# Reverting to the last cursor position
	my $offset = $states{$state_key} || 0;
	if ($offset <= $size) {
		print STDERR "seeking to offset:$offset\n" if $verbose;
		sysseek(FILE, $offset, SEEK_SET);
	} else {
		print STDERR "file was truncated, restarting from the beginning\n" if $verbose;
		$offset = 0;
	}

	# reading until the end
	my $buffer;
	while ((my $read_count = sysread (FILE, $buffer, 4096)) > 0) {
		$offset += $read_count;
		print $buffer;
		print STDERR "read_count:$read_count, offset:$offset\n" if $verbose;
	}

	# Nothing to read anymore
	close(FILE);
	$states{$state_key} = $offset;
}

# sync the states
untie(%states);
