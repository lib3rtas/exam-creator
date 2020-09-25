package Reader;
use v5.32;
use Mouse; # automatically turns on strict and warnings
use feature 'signatures';
use experimental 'signatures';
use feature 'switch';
use experimental 'switch';

# load class definitions
use lib '.';
use States;
use Models;
use Constants;

sub read_exam($self, $file_name) {
    # open file
    my $FILE;
    open($FILE, '<', $file_name) or die $!; #TODO better debug information for user

    # initialize objects for line processing
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
    while(my $line = readline($FILE)){
        state $current_state = Header_State->new();

        # decide on the line type and let the state handle it
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
    close($FILE);
    
    return ($header, @questions);
}

__PACKAGE__->meta->make_immutable();