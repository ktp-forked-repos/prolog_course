tag(TAG) -->
   "<", word(TAG), ">".

endtag(TAG) -->
   "</", word(TAG), ">".

solotag(TAG) -->
   "<", word(TAG), "/>".

word(WORD) --> { var(WORD), ! },
   chars(CHARS), { atom_codes(WORD, CHARS) }.
word(WORD) --> { nonvar(WORD), number(WORD) },
   { number_codes(WORD, CHARS) }, chars(CHARS).
word(WORD) --> { nonvar(WORD) },
   { atom_codes(WORD, CHARS) }, chars(CHARS).

chars([X|Y]) --> char(X), chars(Y).
chars([]) --> [].

char(X) --> [X], { is_char(X) }.

is_char(X) :- X >= 0'a, X =< 0'z, !.
is_char(X) :- X >= 0'A, X =< 0'Z, !.
is_char(X) :- X >= 0'0, X =< 0'9, !.
is_char(0'_).

flight_xml(flight(ID, FROM, TO)) -->
   tag(flight),
   tag(id), word(ID), endtag(id),
   tag(from), word(FROM), endtag(from),
   tag(to), word(TO), endtag(to),
   endtag(flight).

test :-
   flight_xml(flight(101,cvg,lax), Cs, ""),
   string_list(S, Cs),
   write(S), nl,
   string_list(S, C2s),
   flight_xml(F, C2s, ""),
   write(F), nl.
