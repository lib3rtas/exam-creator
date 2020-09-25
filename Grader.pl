#! /usr/bin/env perl
use v5.32;
use strict;
use warnings;
use diagnostics;
use feature 'signatures';
use experimental 'signatures';

# load own class definitions
use lib '.';
use Models;
use Reader;
use Comparer;

# Process arguments
my $number_arguments = $#ARGV + 1;
unless($number_arguments >= 2){
    die qq{Invalid number of arguments.};
}

# initalize comparer & reader
my $comparer = Comparer->new();
my $reader = Reader->new();

# read in master file
my ($master_header, @master_questions) = $reader->read_exam($ARGV[0]);

# grade each given student exam
for(my $i=1; $i <= $#answers; $i++){
    my ($exam_header, @exam_questions) = $reader->read_exam($ARGV[$i]);

    $comparer->compare_file($ARGV[$i], $master_header, $exam_header, \@master_questions, \@exam_questions);
}
