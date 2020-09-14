#! /usr/bin/env perl
use v5.32;
use strict;
use warnings;
#use diagnostics;
use feature 'signatures';
use experimental 'signatures';
use lib '.';
use States;
use Constants;

# Process arguments
my $number_arguments = $#ARGV + 1;
unless($number_arguments == 1){
    die qq{Invalid number of arguments.};
}

my $master_file = $ARGV[0];
open(FILE, '<', '../master_file.txt') or die $!;

while(my $line = readline(FILE)){
    deduce_line_type($line);
}

close FILE;

sub deduce_line_type($line){
    if($line =~ /\s+\[/){
        print $line;
    }
}

my $state = Init->new();
say $state->get_type();
$state = Error->new();
say $state->get_type();
say $Constants::States{INIT};
