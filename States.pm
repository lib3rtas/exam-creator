package Error_State;
use v5.32;
use Mouse; # automatically turns on strict and warnings
use Constants;
use States;
use feature 'signatures';
use experimental 'signatures';

has 'error_message' => (is => 'rw', isa => 'Str');   

sub get_type(){
    return $Constants::States{'ERROR'};
}

__PACKAGE__->meta->make_immutable();

package Header_State;
use v5.32;
use Mouse; # automatically turns on strict and warnings
use Constants;
use States;
use feature 'signatures';
use experimental 'signatures';

sub get_type {
    return $Constants::States{'HEADER'};
}

sub handle_question_line ($self, $state_, $line_, $current_question_, $questions_, $header_) {
    $header_->append_line_to_header(${$line_});
    return 1;
}

sub handle_unmarked_answer_line ($self, $state_, $line_, $current_question_, $questions_, $header_) {
    $header_->append_line_to_header(${$line_});
    return 1;
}

sub handle_marked_answer_line ($self, $state_, $line_, $current_question_, $questions_, $header_) {
    $header_->append_line_to_header(${$line_});
    return 1;
}

sub handle_seperator_line ($self, $state_, $line_, $current_question_, $questions_, $header_) {
    ${$state_} = Question_State->new();
    return 1;
}

sub handle_text_line ($self, $state_, $line_, $current_question_, $questions_, $header_) {
    $header_->append_line_to_header(${$line_});
    return 1;
}

sub handle_empty_line ($self, $state_, $line_, $current_question_, $questions_, $header_) {
    $header_->append_line_to_header(${$line_});
    return 1;
}

sub handle_unknown_line ($self, $state_, $line_, $current_question_, $questions_, $header_) {
    ${$state_} = Error_State->new();
    return 1;
}

__PACKAGE__->meta->make_immutable();

package Question_State;
use v5.32;
use Mouse; # automatically turns on strict and warnings
use Constants;
use States;
use Models;
use feature 'signatures';
use experimental 'signatures';

sub get_type(){
    return $Constants::States{'QUESTION'};
}

sub handle_question_line ($self, $state_, $line_, $current_question_, $questions_, $header_) {
    ${$current_question_}->append_line_to_question(${$line_});
    return 1;
}

sub handle_unmarked_answer_line ($self, $state_, $line_, $current_question_, $questions_, $header_) {
    push(@{${$current_question_}->get_answers()}, ${$line_});
    push(@{${$current_question_}->get_answers_value()}, 0);
    ${$state_} = Answer_State->new();
    return 1;
}

sub handle_marked_answer_line ($self, $state_, $line_, $current_question_, $questions_, $header_) {
    push(@{${$current_question_}->get_answers()}, ${$line_});
    push(@{${$current_question_}->get_answers_value()}, 1);
    ${$state_} = Answer_State->new();
    return 1;
}

sub handle_seperator_line ($self, $state_, $line_, $current_question_, $questions_, $header_) {
    ${$state_} = Error_State->new(
        error_message => "No answers belonging for question at line:\n${$line_}"
    );
    return 1;
}

sub handle_text_line ($self, $state_, $line_, $current_question_, $questions_, $header_) {
    ${$current_question_}->append_line_to_question(${$line_});
    return 1;
}

sub handle_empty_line ($self, $state_, $line_, $current_question_, $questions_, $header_) {
    ${$current_question_}->append_line_to_question(${$line_});
    return 1;
}

sub handle_unknown_line ($self, $state_, $line_, $current_question_, $questions_, $header_) {
    ${$state_} = Error_State->new(
        error_message => "Encountered unknown line type in line:\n${$line_}"
    );
    return 1;
}

__PACKAGE__->meta->make_immutable();


package Answer_State;
use v5.32;
use Mouse; # automatically turns on strict and warnings
use Constants;
use States;
use Models;
use feature 'signatures';
use experimental 'signatures';

sub get_type(){
    return $Constants::States{'ANSWER'};
}

sub handle_question_line ($self, $state_, $line_, $current_question_, $questions_, $header_) {
    ${$state_} = Error_State->new(
        error_message => "Encountered unknown line type in line:\n${$line_}"
    );
    return 1;
}

sub handle_unmarked_answer_line ($self, $state_, $line_, $current_question_, $questions_, $header_) {
    push(@{${$current_question_}->get_answers()}, ${$line_});
    push(@{${$current_question_}->get_answers_value()}, 0);
    ${$state_} = Answer_State->new();
    return 1;
}

sub handle_marked_answer_line ($self, $state_, $line_, $current_question_, $questions_, $header_) {
    push(@{${$current_question_}->get_answers()}, ${$line_});
    push(@{${$current_question_}->get_answers_value()}, 1);
    ${$state_} = Answer_State->new();
    return 1;
}

sub handle_seperator_line ($self, $state_, $line_, $current_question_, $questions_, $header_) {
    push(@{$questions_}, ${$current_question_});
    ${$current_question_} = Question->new(
        answers => [],
        answers_value => [], 
        question => ""
    );
    ${$state_} = Question_State->new();
    return 1;
}

sub handle_text_line ($self, $state_, $line_, $current_question_, $questions_, $header_) {
    ${$current_question_}->append_line_to_answer(-1, ${$line_});
    return 1;
}

sub handle_empty_line ($self, $state_, $line_, $current_question_, $questions_, $header_) {
    ${$current_question_}->append_line_to_answer(-1, ${$line_});
    return 1;
}

sub handle_unknown_line ($self, $state_, $line_, $current_question_, $questions_, $header_) {
    ${$state_} = Error_State->new(
        error_message => "Encountered unknown line type in line:\n${$line_}"
    );
    return 1;
}

__PACKAGE__->meta->make_immutable();