package Question;
use v5.32;
use Mouse; # automatically turns on strict and warnings
use diagnostics;

# attributes
has 'answers' => (is => 'rw', isa => 'ArrayRef');       # storing the answers as strings
has 'answers_value' => (is => 'rw', isa => 'ArrayRef'); # storing if answer is right/wrong, matching index with @answers
has 'question' => (is => 'rw', isa => 'Str');           # question string

sub append_line_to_question {
    # parameters
    my $self = shift;
    my $line = shift;

    # append the line given to the question
    my $tmp = $self->question . $line; #
    $self->question($tmp);
    return 1;
}

sub append_line_to_answer {
    # parameters
    my $self          = shift;
    my $answer_number = shift;
    my $line          = shift;

    # append the line given to a specific answer
    @{$self->answers}[$answer_number] .= $line;
    return 1;
}

sub print_answers {
    # parameters
    my $self = shift;
    my $output = shift;

    # append the line given to a specific answer
    foreach my $answer (@{$self->answers}){
        print $answer;
    }
}

__PACKAGE__->meta->make_immutable();



package Header;
use v5.32;
use Mouse; # automatically turns on strict and warnings
use diagnostics;

has 'content' => (is => 'rw', isa => 'Str');   # question string

sub append_line_to_header {
    # parameters
    my $self = shift;
    my $line = shift;

    # append the line given to the question
    my $tmp = $self->content . $line; #
    $self->content($tmp);
    return 1;
}

__PACKAGE__->meta->make_immutable();