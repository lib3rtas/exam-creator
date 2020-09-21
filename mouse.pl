use v5.32;
package Point;
use Mouse; # automatically turns on strict and warnings
 
has 'x' => (is => 'rw', isa => 'ArrayRef');

sub set_array{
    my $self = shift;
    my $arr_ref = shift;
    $self->x($arr_ref);
}

__PACKAGE__->meta->make_immutable();

use lib '.';
use Models;

my @a = (1,2,3);
my @b = ('a','b','c');

my $test = Point->new(
    x => \@a,
);

#say @{$test->x}[0];
#my @tmp = @{$test->x};
#say $tmp[0];
#$test->set_array(\@b);
#say $tmp[0];
#say @{$test->x}[0];

my $q = Question->new(
    answers => \@a,
    answers_value => \@b,
    question => "Empty\n"
);

print $q->question;
$q->append_line_to_question("New Line to Append\n");
print $q->question;

$q->append_line_to_answer(0, "Test");
$q->print_answers();
