# Exam-Creator
Generates text exams from a master file. Can grade and analyze the answered exams.

## Code structure
The project is implemented in a object oriented fashion with the CPAN library Mouse. As OOP is for me personally the most often used paradigm I was interested to try OOP in Perl. The base program is imperative and OOP is used where it did fit in well. For example as Data Model Objects or to implement a state machine.

## Code conventions
All variables are named in snake_case style.
```
my very_long_variable_name = "Example Var";
```

References are indicated with an underscore.
```
my @array = (1, 2, 3);
my $array_ = \@array;
```