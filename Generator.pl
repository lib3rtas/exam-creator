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
use States;
use Models;
use Constants;

# Process arguments
my $number_arguments = $#ARGV + 1;
unless($number_arguments == 1){
    die qq{Invalid number of arguments.};
}

# open file
my $master_file = $ARGV[0];
open(FILE, '<', $master_file) or die $!; #TODO better debug information for user

my $header = Header->new(
    content => ""
);
my @questions = ();
my $current_question = Question->new(
    answers => [],
    answers_value => [], 
    question => ""
);

# process the master file linewise
while(my $line = readline(FILE)){
    state $current_state = Header_State->new();

    given ($line) {

        when ($Constants::question_regex) { 
            $current_state->handle_question_line(
                \$current_state,
                \$line,
                \$current_question,
                \@questions,
                $header
            );
        }

        when ($Constants::unmarked_answer_regex) { 
            $current_state->handle_unmarked_answer_line(
                \$current_state,
                \$line,
                \$current_question,
                \@questions,
                $header
            );
        }

        when ($Constants::marked_answer_regex) { 
            $current_state->handle_marked_answer_line(
                \$current_state,
                \$line,
                \$current_question,
                \@questions,
                $header
            );
        }

        when ($Constants::seperator_regex) { 
            $current_state->handle_seperator_line(
                \$current_state,
                \$line,
                \$current_question,
                \@questions,
                $header
            );
        }

        when ($Constants::text_regex) { 
            $current_state->handle_text_line(
                \$current_state,
                \$line,
                \$current_question,
                \@questions,
                $header
            );
        }

        when ($Constants::empty_line_regex) { 
            $current_state->handle_empty_line(
                \$current_state,
                \$line,
                \$current_question,
                \@questions,
                $header
            );
        }
        
        default { 
            $current_state->handle_unknown_line(
                \$current_state,
                \$line,
                \$current_question,
                \@questions,
                $header
            );
        }
    }
}
close(FILE);

# generate an exam file
my $EXAM_FILE;
open($EXAM_FILE, '>', create_exam_title()) or die $!;

my $exam_string = "";
$exam_string .= $header->content;
$exam_string .= $Constants::seperator_line;

foreach my $question (@questions){
    $exam_string .= $question->question;
    $exam_string .= $question->get_randomized_answers_string();
    $exam_string .= $Constants::seperator_line;
}

print $EXAM_FILE $exam_string;

# helper methods
sub create_exam_title(){
    my ($second,$minute,$hour,$day,$month,$year) = localtime();
    # create timestamp in format YYYYMMDD-hhmmss-
    my $timestamp = sprintf("%.4d%.2d%.2d-%.2d%.2d%.2d-", $year+1900, $month+1, $day, $hour, $minute, $second);
    return "$timestamp$master_file";
}