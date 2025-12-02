USING: arrays io io.encodings.utf8 io.files kernel math
math.functions math.parser math.primes.factors prettyprint
ranges sequences sets splitting ;
IN: scratchpad

: digit-count ( n -- digits )
    integer-log10 1 + ;

: next-power-of-10 ( n -- n )
    digit-count 10 swap ^ ;

: interval-can-be-decomposed? ( interval -- ? )
    first2 [ next-power-of-10 ] dip <= ;

! decompose a closed interval like [5, 123]
! into an array of intervals of consistent digit count,
! e.g. [5, 9] U [10, 99] U [100, 123]
:: decompose-interval ( interval -- intervals )
    V{ } clone :> ivals
    interval
    [ dup interval-can-be-decomposed? ]
    [ first2
      [ dup next-power-of-10 dup
        [ 1 - 2array ivals swap suffix! drop ] dip
      ] dip 2array
    ]
    while
    ivals swap suffix! >array ;

: halve ( abcd -- ab )
    dup integer-log10 2 /i 1 + [ 10 /i ] times ;

: double ( ab -- abab )
    dup dup digit-count [ 10 * ] times + ;

:: count-reps2 ( a b -- n )
    a halve b halve [a..b]
    [ double ] map
    [ [ a swap <= ] [ b <= ] bi and ] filter ;

! 60 nontrivial-divisors => { 2 3 4 5 6 10 12 15 20 30 60 }
: nontrivial-divisors ( n -- divisors )
    divisors [ 1 > ] filter ;

! 45678 2 truncate-digits => 45
: truncate-digits ( n digits -- n' )
    [ dup digit-count ] dip - [ 10 /i ] times ;

! 123 3 repeat-digits => 123123123
: repeat-digits ( n reps -- n' )
    swap number>string <repetition> concat string>number ;

:: count-repsN ( a b N -- n )
    a digit-count N /i :> digits
    a b [ digits truncate-digits ] bi@
    [a..b]
    [ N repeat-digits ] map
    [ [ a swap <= ] [ b <= ] bi and ] filter ;

"day2.txt"
utf8 file-lines first
"," split
[ "-" split [ string>number ] map ] map
[ decompose-interval ] map concat

dup
! first star
[ first digit-count even? ] filter
[ first2 count-reps2 ] map
concat sum
. nl

! second star
[
  ! "i: " write dup .
  dup first
  digit-count
  nontrivial-divisors
  [ [ first2 ] dip count-repsN ] with map
  concat
  members ! uniq
  ! "o: " write dup .
] map
concat sum
. nl
