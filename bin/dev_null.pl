#! /usr/bin/perl
# Poor man's dev null
# (c) 2009 - Apache-2.0 - Steve Schnepp <steve.schnepp@pwkf.org>
# Useful to have portable scripts in Unix & Windows 
#
# Just use my_command | dev_null.pl instead of my_command > /dev/null

while (<>) {
        # Just do nothing
}
