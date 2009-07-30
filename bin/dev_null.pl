#! /usr/bin/perl
# Poor man's dev null
# (c) LGPL 2009 - Steve Schnepp
# Useful to have portable scripts in Unix & Windows 
#
# Just use my_command | dev_null.pl instead of my_command > /dev/null

while (<>) {
        # Just do nothing
}
