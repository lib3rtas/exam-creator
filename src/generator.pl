#! /usr/bin/env perl
use v5.32;
use strict;
use warnings;
#use diagnostics;

# Process arguments
my $number_arguments = $#ARGV + 1;
unless($number_arguments == 1){
    die qq{Invalid number of arguments.};
}

my $master_file = $ARGV[0];
open(FILE, '<', '../master_file.txt') or die $!;

while(my $line = readline(FILE)){
    print $line;
}