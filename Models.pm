package Question;
use v5.32;
use Mouse; # automatically turns on strict and warnings
use List::Util 'shuffle';
use feature 'signatures';
use experimental 'signatures';
use Constants;

# attributes
has 'answers' => (is => 'rw', isa => 'ArrayRef');       # storing the answers as strings
has 'answers_value' => (is => 'rw', isa => 'ArrayRef'); # storing if answer is right/wrong, matching index with @answers
has 'question' => (is => 'rw', isa => 'Str');           # question string

sub get_answers($self) {
    return $self->answers;
}
sub get_answers_value($self) {
    return $self->answers_value;
}

sub append_line_to_question($self, $line) {
    # append the line given to the question
    my $tmp = $self->question . $line; #
    $self->question($tmp);
    return 1;
}

sub append_line_to_answer($self, $answer_number, $line) {
    # append the line given to a specific answer
    @{$self->answers}[$answer_number] .= $line;
    return 1;
}

sub print_answers ($self, $filehandle) {
    my @tmp = @{$self->answers};
    my @tmp_val = @{$self->answers_value};
    for(my $i=0; $i <= $#tmp; $i++){
        if($tmp_val[$i]){}
	    print $filehandle $tmp[$i];
    }
}

sub get_randomized_answers_string($self) {
    my @answers = shuffle(@{$self->answers});
    my $answers_string = "";

    for(my $i=0; $i <= $#answers; $i++){
        # remove unnecessary newlines from answer
        $answers[$i] = $answers[$i] =~ s/\n\n/\n/grx;

        # if answer is marked/correct remove marker and append to string
        if($answers[$i] =~ qr/^\s*\[\s*X\s*\]/){
            $answers_string .= $answers[$i] =~ s/^\s*\[\s*X\s*\]/$Constants::answer_identation\[ \]/gr; 
        } else {
            $answers_string .= $answers[$i];
        }
    }

    return $answers_string;
}

__PACKAGE__->meta->make_immutable();


package Header;
use v5.32;
use Mouse; # automatically turns on strict and warnings
use feature 'signatures';
use experimental 'signatures';

has 'content' => (is => 'rw', isa => 'Str');   # question string

sub append_line_to_header($self, $line) {
    # append the line given to the question
    my $tmp = $self->content . $line; #
    $self->content($tmp);
    return 1;
}

__PACKAGE__->meta->make_immutable();