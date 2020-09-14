package Constants;
use v5.32;
use strict;
use warnings;

our %States = (
    'ERROR' => 0,
    'INIT' => 1,
    'HEADER' => 2,
    'QUESTION' => 3,
    'ANSWER' => 4,
    'END' => 5,
);