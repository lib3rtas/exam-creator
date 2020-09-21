package Constants;
use v5.32;
use strict;
use warnings;

our %states = (
    'ERROR'     => 0,
    'HEADER'    => 1,
    'QUESTION'  => 2,
    'ANSWER'    => 3,
    'END'       => 4,
);

our $question_regex        = qr/^ \d+ \. /x;
our $unmarked_answer_regex = qr/^ \s* \[ \s* \] /x;
our $marked_answer_regex   = qr/^ \s* \[ \s* X \s* \] /x;
our $seperator_regex       = qr/^ _{5,} /x;
our $text_regex            = qr/^ \N+ /x;
our $empty_line_regex      = qr/^\n/x;