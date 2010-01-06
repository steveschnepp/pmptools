#! /usr/bin/perl
# Poor man's Netcat, the famous "TCP/IP swiss army knife"
# Only the basic functions are replicated : 
# - TCP only
# - only : "hostname port" or "-l" with "-p port" 

use strict;
use warnings;

use IO::Socket;
use Getopt::Long;

my $help;
my $verbose;

my $local_port;
my $listen;

my $result = GetOptions(
        "help|h" => \$help,
        "verbose|v" => \$verbose,

	"local-port|p=i" => \$local_port,
	"listen|l" => \$listen,
);

if ($help) {
        print STDERR "Perl loose port of netcat(1)\n";
        print STDERR "usage : $0 [-p local_port] hostname port (client)\n";
        print STDERR "   or : $0 -l -p local_port (server)\n";
        exit(1);
}
	
# No need to close the socks as they are closed 
# when going out-of-scope
if ($listen) {
	if (! $local_port) {
		die "You must specify the port to listen to in server mode\n";
	}

	# server mode
	my $l_sock = IO::Socket::INET->new(
		Proto => "tcp",
		LocalPort => $local_port,
		Listen => 1,
		Reuse => 1,
	) or die "Could not create socket: $!";

	my $a_sock = $l_sock->accept(); 
	while(<$a_sock>) {
		print $_;
	}
} else {
	if (scalar @ARGV < 2) {
		die "You must specify where to connect in client mode\n";
	}

	my ($remote_host, $remote_port) = @ARGV;

	# client mode
	my $c_sock = IO::Socket::INET->new(
		Proto => "tcp",
		LocalPort => $local_port,
		PeerAddr => $remote_host,
		PeerPort => $remote_port,
	) or die "Could not create socket: $!";

	while (<STDIN>) {
		print $c_sock $_;
	}
}
