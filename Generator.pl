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
open(FILE, '<', 'master_file.txt') or die $!; #TODO better debug information for user

my @questions = ();
my $header = Header->new(
    content => ""
);
my $current_question = Question->new(
    answers => [],
    answers_value => [], 
    question => ""
);

while(my $line = readline(FILE)){
    readline();
    state $current_state = Header_State->new();
    given ($line) {
        when ($Constants::question_regex) { 
            print 'QESTION        '; 
            print $line; 
            $current_state->handle_question_line(
                \$current_state,
                \$line,
                \$current_question,
                \@questions,
                $header
            );
        }
        when ($Constants::unmarked_answer_regex) { 
            print 'UNMARKED_ANSWER'; 
            print $line; 
            $current_state->handle_unmarked_answer_line(
                \$current_state,
                \$line,
                \$current_question,
                \@questions,
                $header
            );
        }
        when ($Constants::marked_answer_regex) { 
            print 'MARKED_ANSWER  '; 
            print $line; 
            $current_state->handle_marked_answer_line(
                \$current_state,
                \$line,
                \$current_question,
                \@questions,
                $header
            );
        }
        when ($Constants::seperator_regex) { 
            print 'SEPERATOR      '; 
            print $line; 
            $current_state->handle_seperator_line(
                \$current_state,
                \$line,
                \$current_question,
                \@questions,
                $header
            );
        }
        when ($Constants::text_regex) { 
            print 'TEXT           '; 
            print $line; 
            $current_state->handle_text_line(
                \$current_state,
                \$line,
                \$current_question,
                \@questions,
                $header
            );
        }
        when ($Constants::empty_line_regex) { 
            print 'EMPTY_LINE     ';
            print $line; 
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

print $questions[0];

print "\n"; 
print "--------- HEADER ------------";
print $header->content;
print "--------- HEADER ------------";

print "\n"; 
print "--------- QUESTIONS ------------";
foreach my $quest (@questions){
    print $quest->question;
    $quest->print_answers();
    print "--------- NEXT ------------"; 
}
print "\n"; 
print "--------- QUESTIONS ------------";

print "\n"; 

close FILE;
