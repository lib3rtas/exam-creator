# Exam-Creator
Generates text exams from a master file. Can grade and analyze the answered exams.
The program solves the main tasks 1a and 1b. It attempts to solve part2, which is not completely implemented, therefore inactive (See Fuzzy.pm).

! In an attempt to refactor the Grader.pl I ran into an issue and didn't manage to resolve it until now. Therefore task 1b (Grader) is not compiling !

## Usage
Exams can be generated with:
```
perl Generator.pl "name_of_master_file.txt"
```

Exams can be graded with:
perl Grader.pl "name_of_master_file.txt" "student_exam_1" "student_exam_2" ...

### Testrun
A simple testrun could be executed examplary like this:
```
perl Generator.pl master_file.txt

perl Grader.pl master_file.txt 20200925-231302-master_file.txt
```


## Code structure
The project is implemented in a object oriented fashion with the CPAN library Mouse. As OOP is for me personally the most often used paradigm I was interested to try OOP in Perl. The base program is imperative and OOP is used where it did fit in. For example as Data Model Objects or to implement a state machine.

## Overview

### Main Files
Generator.pl    generates exam files based on master file

Grader.pl       grades exams files based on a given master file   

### Modules
Reader.pm        handles reading in of exam files and transforming them to models(objects)

Models.pm        contains core classes Question and Header

States.pm        contains states and most of the state transition logic

Constants.pm     contain several constants in order have easier maintanance of "global" information

## Code conventions / Information for better readability
All variables are named in snake_case style.
```
my very_long_variable_name = "Example Var";
```

References are indicated with an underscore.
```
my @array = (1, 2, 3);
my $array_ = \@array;
```

I used 
