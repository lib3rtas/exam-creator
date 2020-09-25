#! /usr/bin/env perl
use v5.32;
use strict;
use warnings;
use diagnostics;
use feature 'signatures';
use experimental 'signatures';
use feature 'switch';
use experimental 'switch';

# load own class definitions
use lib '.';
use Models;
use Reader;

# Process arguments
my $number_arguments = $#ARGV + 1;
unless($number_arguments == 1){
    die qq{Invalid number of arguments.};
}

my $reader = Reader->new();
my ($header, @questions) = $reader->read_exam($ARGV[0]);

#generate an exam file
my $EXAM_FILE;
open($EXAM_FILE, '>', create_exam_title($ARGV[0])) or die $!;

my $exam_string = "";
$exam_string .= $header->content;
$exam_string .= $Constants::seperator_line;

foreach my $question (@questions){
    $exam_string .= $question->question;
    $exam_string .= $question->get_randomized_answers_string();
    $exam_string .= $Constants::seperator_line;
}

print($EXAM_FILE $exam_string);
close($EXAM_FILE);

# helper method
sub create_exam_title($file_name) {
    my ($second,$minute,$hour,$day,$month,$year) = localtime();
    # create timestamp in format YYYYMMDD-hhmmss-
    my $timestamp = sprintf("%.4d%.2d%.2d-%.2d%.2d%.2d-", $year+1900, $month+1, $day, $hour, $minute, $second);
    return "$timestamp$file_name";
}