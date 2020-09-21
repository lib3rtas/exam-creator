package Error_State;
use v5.32;
use Mouse; # automatically turns on strict and warnings
use Constants;
use States;

sub get_type(){
    return $Constants::States{'ERROR'};
}

__PACKAGE__->meta->make_immutable();

package Header_State;
use v5.32;
use Mouse; # automatically turns on strict and warnings
use Constants;
use States;

sub get_type {
    return $Constants::States{'HEADER'};
}

sub handle_question_line {
    my $self                 = shift;
    my $state_ref            = shift;
    my $line_ref             = shift;
    my $current_question_ref = shift;
    my $questions_ref        = shift;
    my $header_ref           = shift;

    $header_ref->append_line_to_header(${$line_ref});
    return 1;
}

sub handle_unmarked_answer_line {
    my $self                 = shift;
    my $state_ref            = shift;
    my $line_ref             = shift;
    my $current_question_ref = shift;
    my $questions_ref        = shift;
    my $header_ref           = shift;

    $header_ref->append_line_to_header(${$line_ref});
    return 1;
}

sub handle_marked_answer_line {
    my $self                 = shift;
    my $state_ref            = shift;
    my $line_ref             = shift;
    my $current_question_ref = shift;
    my $questions_ref        = shift;
    my $header_ref           = shift;

    $header_ref->append_line_to_header(${$line_ref});
    return 1;
}

sub handle_seperator_line {
    my $self                 = shift;
    my $state_ref            = shift;
    my $line_ref             = shift;
    my $current_question_ref = shift;
    my $questions_ref        = shift;
    my $header_ref           = shift;

    $state_ref = Question_State->new();
    return 1;
}

sub handle_text_line {
    my $self                 = shift;
    my $state_ref            = shift;
    my $line_ref             = shift;
    my $current_question_ref = shift;
    my $questions_ref        = shift;
    my $header_ref           = shift;

    $header_ref->append_line_to_header(${$line_ref});
    return 1;
}

sub handle_empty_line {
    my $self                 = shift;
    my $state_ref            = shift;
    my $line_ref             = shift;
    my $current_question_ref = shift;
    my $questions_ref        = shift;
    my $header_ref           = shift;

    $header_ref->append_line_to_header(${$line_ref});
    return 1;
}

sub handle_unknown_line {
    my $self                 = shift;
    my $state_ref            = shift;
    my $line_ref             = shift;
    my $current_question_ref = shift;
    my $questions_ref        = shift;
    my $header_ref           = shift;

    $state_ref = Error_State->new();
    return 1;
}


__PACKAGE__->meta->make_immutable();

package Question_State;
use v5.32;
use Mouse; # automatically turns on strict and warnings
use Constants;
use States;

sub get_type(){
    return $Constants::States{'QUESTION'};
}

sub handle_question_line {
    my $self                 = shift;
    my $state_ref            = shift;
    my $line_ref             = shift;
    my $current_question_ref = shift;
    my $questions_ref        = shift;
    my $header_ref           = shift;

    $state_ref = Error_State->new();
    return 1;
}

sub handle_unmarked_answer_line {
    my $self                 = shift;
    my $state_ref            = shift;
    my $line_ref             = shift;
    my $current_question_ref = shift;
    my $questions_ref        = shift;
    my $header_ref           = shift;

    $header_ref->append_line_to_header(${$line_ref});
    return 1;
}

sub handle_marked_answer_line {
    my $self                 = shift;
    my $state_ref            = shift;
    my $line_ref             = shift;
    my $current_question_ref = shift;
    my $questions_ref        = shift;
    my $header_ref           = shift;

    $header_ref->append_line_to_header(${$line_ref});
    return 1;
}

sub handle_seperator_line {
    my $self                 = shift;
    my $state_ref            = shift;
    my $line_ref             = shift;
    my $current_question_ref = shift;
    my $questions_ref        = shift;
    my $header_ref           = shift;

    $header_ref->append_line_to_header(${$line_ref});
    return 1;
}

sub handle_text_line {
    my $self                 = shift;
    my $state_ref            = shift;
    my $line_ref             = shift;
    my $current_question_ref = shift;
    my $questions_ref        = shift;
    my $header_ref           = shift;

    $header_ref->append_line_to_header(${$line_ref});
    return 1;
}

sub handle_empty_line {
    my $self                 = shift;
    my $state_ref            = shift;
    my $line_ref             = shift;
    my $current_question_ref = shift;
    my $questions_ref        = shift;
    my $header_ref           = shift;

    $header_ref->append_line_to_header(${$line_ref});
    return 1;
}

sub handle_unknown_line {
    my $self                 = shift;
    my $state_ref            = shift;
    my $line_ref             = shift;
    my $current_question_ref = shift;
    my $questions_ref        = shift;
    my $header_ref           = shift;

    $header_ref->append_line_to_header(${$line_ref});
    return 1;
}

__PACKAGE__->meta->make_immutable();


package Answer_State;
use v5.32;
use Mouse; # automatically turns on strict and warnings
use Constants;
use States;

sub get_type(){
    return $Constants::States{'ANSWER'};
}


__PACKAGE__->meta->make_immutable();

package End_State;
use v5.32;
use Mouse; # automatically turns on strict and warnings
use Constants;
use States;

sub get_type(){
    return $Constants::States{'END'};
}

__PACKAGE__->meta->make_immutable();
