USING: arrays formatting io io.encodings.utf8 io.files kernel
math math.parser prettyprint sequences sequences.deep splitting
;
IN: scratchpad

: parse-line ( line -- signed-int )
    "L" "+" replace
    "R" "-" replace
    string>number ;

: explode ( deltas -- deltas )
    [ [ abs ] [ sgn ] bi <array> ] map concat ;

: knob-states ( deltas -- knob-values )
    50 [ + 100 rem ] accumulate* ;

: main ( -- )
    "day1.txt" utf8 file-lines
    [ parse-line ] map
    explode ! for 2nd star
    knob-states
    [ 0 = ] count . ;

MAIN: main
