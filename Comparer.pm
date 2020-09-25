package Comparer;
use v5.32;
use Mouse; # automatically turns on strict and warnings
use feature 'signatures';
use experimental 'signatures';

# load class definitions
use lib '.';
use Models;

sub compare_file($self, $exam_file, $master_header, $exam_header, $master_questions_, $exam_questions_){
    my @errors = ();
    my @master_questions   = @{$master_questions_};
    my @exam_questions     = @{$exam_questions_};

    my @header_errors                    = compare_header($master_header, $exam_header);
    my ($continuable, @questions_errors) = compare_questions($master_questions_, $exam_questions_);
    
    # if a complete question is missing the answer analyzing and grading should be managed manually -> stop of automatic grading for this exam
    my @answers_errors;
    if($continuable) {
        @answers_errors = compare_answers($master_questions_, $exam_questions_);
    } else {
        @answers_errors = ("Differing number of questions. Exam must be inspected and graded manually!");
    }
    
    push(@errors, @header_errors, @questions_errors, @answers_errors);
    return @errors;
}

sub compare_header($self, $master_header, $exam_header) {
    my @errors = ();

    unless(compare_strings($master_header, $exam_header)){
        push(@errors, "Header was modified. Manual investigation recommended.");
    }

    return @errors;
}

sub compare_questions($self, $master_questions_, $exam_questions_) {
    my @errors = ();
    my @master_questions   = @{$master_questions_};
    my @exam_questions     = @{$exam_questions_};


    # handle a different number of questions in master and exam file
    unless($#master_questions == $#exam_questions) {
        push(@errors, "Number of questions differs. Manual investigation necessary.");
        
        # compare and count until questions differ, to find the first difference
        my $i=0; 
        while(
                $i <= $#master_questions && 
                compare_strings($master_questions[$i]->question, $exam_questions[$i]->question)
             ) { $i++; }
        $i++; # add another one because array starts at zero 

        push(@errors, "First difference of questions occured at question number $i.");
        return (0, @errors);

    } else {
        #compare each questions intergrity
        for(my $i=0; $i <= $#master_questions; $i++){
            unless(compare_strings($master_questions[$i]->question, $exam_questions[$i]->question)){
                my $tmp = $i+1; # add one because array starts at zero 
                push(@errors, "Question number $tmp differs in master and exam file. Manual investigation necessary.");
            }
        }
        return (1, @errors);
    }
}

sub compare_answers($self, $master_questions, $exam_questions) {
        my @errors = ();
        my $points = 0;
        my @master_questions   = @{$master_questions_};
        my @exam_questions     = @{$exam_questions_};

        my @current_master_answers;
        my @current_exam_answers;
        # for each question in the master file 
        for(my $i=0; $i <= $#master_questions; $i++){
            @current_master_answers = @{$master_questions[$i]->answers};
            @current_exam_answers = @{$exam_questions[$i]->answers};

            # for each answer in the question find the corresponding answer of the students question and compare them
            for(my $j=0; $j <= $#current_master_answers; $j++){
                my $answer_master = get_bare_answer_string($current_master_answers[$j]); 

                # try to map the answer from the master file to an answer in the exam file
                my $k = 0;
                while( $k <= $#current_exam_answers && 
                       !compare_strings(
                           get_bare_answer_string($current_exam_answers[$k]), 
                           $answer_master
                        )
                    )
                    { $k++; }

                # answer successfully mapped from master file to exam file
                if($k <= $#current_exam_answers){
                    # if the answer is correct and the student marked the answer correctly give a point
                    if($master_questions[$i]->answers_value[$j] && $exam_questions[$i]->answers_value[$k]) { 
                        $points++; 
                    }
                } else { # no answer could be mapped
                    push(@errors, "For question $i a specific answer couldn't be found in the exam file. Manual investigation necessary.");
                }
            }
        }

        return ($points, @errors);
}

sub compare_strings($self, $string_a, $string_b){
    return $string_a eq $string_b;
}

sub get_bare_answer_string($self, $string){
    my $result = ($string =~ s/^\s*\[\s*\]//gr) =~ s/^\s*\[\s*X\s*\]//gr;
    return $result;
}

__PACKAGE__->meta->make_immutable();