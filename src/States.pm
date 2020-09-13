package Init;
use v5.32;
use Constants;
use Mouse; # automatically turns on strict and warnings

sub get_type(){
    return $Constants::States{"ERROR"};
}

sub handle_empty_line(){
    die(qq{not implemented yet});
}

sub handle_generic_line(){
    die(qq{not implemented yet});
}

sub handle_question_delimiter(){
    die(qq{not implemented yet});
}

sub handle_question_line(){
    die(qq{not implemented yet});
}

sub handle_answer_line(){
    die(qq{not implemented yet});
}

__PACKAGE__->meta->make_immutable();


package Error;
use v5.32;
use Mouse; # automatically turns on strict and warnings

sub get_type(){
    return 0;
}

sub handle_empty_line(){
    die(qq{not implemented yet});
}

sub handle_generic_line(){
    die(qq{not implemented yet});
}

sub handle_question_delimiter(){
    die(qq{not implemented yet});
}

sub handle_question_line(){
    die(qq{not implemented yet});
}

sub handle_answer_line(){
    die(qq{not implemented yet});
}

__PACKAGE__->meta->make_immutable();

