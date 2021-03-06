% frames.pro
%
% a library of frame predicates.
%

:- ensure_loaded(list).
:- import(list).

:- reconsult(tests).

%--------------------------------------------
% create_frame(Class, Instance)
% creates a new frame of a given class and instance.
%

create_frame(Class, Instance) :-
   F =.. [Class, Instance, []],
   assert(F).

%--------------------------------------------
% frame(Class, Instance, Properties)
%

frame(Class, Instance, Properties) :-
   F =.. [Class, Instance, Properties],
   call(F).

%------------------------------------------------
% add_property(Class, Instance, Property)
% adds a new property to an existing frame instance.
%

add_property(Class, Instance, Property) :-
   F =.. [Class, Instance, PropertyList],
   retract(F),
   F2 =.. [Class, Instance, [Property|PropertyList]],
   assert(F2).

%------------------------------------------------
% remove_property(Class, Instance, Property)
% adds a new property to an existing frame instance.
%


%--------------------------------------------------
% match( Test, PropertyList )
%
% match/2, like member/2, can test if a property = value
% is on a property list, but can also test for other
% conditions..
%
% put in tests for > < >= and =<.
% HINT: These should be in a separate predicate, test/2.
%
% ?- pl(X, PL), match( wheels > 4, PL ).
% X = two ;
% X = five
%
% ?- pl(X, PL), match( color = blue, PL ).
% one ;
% three
%

match( PropTest, [PropVal | _] ) :-
   test(PropTest, PropVal),
   !.
match( PropTest, [_ | Props] ) :-
   match( PropTest, Props ).

test( P > X, P = V ) :- V > X.

%--------------------------------------------------
% Add more tests for properties that are lists.
%
% test for
%   includes(Property, Value),
%   count(P, L),
%   not Test,
%   P = V  when V is in a list.
%
% ?- pl(X, PL), match( includes(color, red), PL ).
% X = six
%
% ?- pl(X, PL), match( count(color, 3), PL ).
% X = five
% X = six
%
% ?- pl(X, PL), match( color = blue, PL ).
% one ;
% three ;
% five
%
% ?- pl(X, PL), match( not wheels > 4, PL )
% X = (all except two and five)

%-------------------------------------------
% If the application declares transitive
% properties, then use them.  In other words
% match takes into account transitive properties.
%
% This is the same logic as used for inheritance.
%
% transitive(word, kind_of).
% transitive(word, contains).
%
% ?- word(X, PL), match( kind_of = life_form, PL ).
% X = orange; X = plant; X = tree
%

%-----------------------------------------------
% match_list(TestList, PropertyList)
%
% matches a list of tests against a property list
%
% ?- pl(X, PL), match_list( [color = blue, wheels = W], PL).
% X = one
% W = 3;
% X = three
% W = 2;
% X = five
% W = 7
%

%--------------------------------------------
% find_frame(Class, Query, Frame).
%
% ?- find_frame(word, shape=disc, W).
% W = pizza ;
% W = frisbee ;
% no
%
% ?- find_frame(pl, [color=blue, wheels>2], PL).
% PL = one ;
% PL = seven ;
% no

%------------------------------------------------
% Final property test
% see if this works:
%
% ?- cannot_eat(P, F).
% P = bob
% F = pizza;
% P = bob
% F = tomato_sauce;
% P = sue
% F = cookies
%


%-------------------------------------------
% If the application declares transitive
% properties, then use them.
%
% transitive(word, kind_of).
% transitive(word, contains).
%

test( P = X, P = V ) :-
   transitive(Class, P),
   not list(V),
   frame(Class, V, Props),
   match(P = X, Props).
test( P = X, P = Vs ) :-
   transitive(Class, P),
   list(Vs),
   member(V, Vs),
   frame(Class, V, Props),
   match(P = X, Props).

test(X, X).

%-----------------------------------------------
% match_list(TestList, PropertyList)
%
% matches a list of tests against a property list
%

match_list( [], _ ).
match_list( [Test|Tests], Properties) :-
   match(Test, Properties),
   match_list(Tests, Properties).



%--------------------------------------------
% find_frame(Class, Instance, Query).
%
% ?- find_frame(word, W, shape=disc).
% W = pizza ;
% W = frisbee ;
% no
%
% ?- find_frame(pl, PL, [color=blue, wheels>2]).
% PL = one ;
% PL = seven ;
% no

find_frame(Class, Instance, Query) :-
   F =.. [Class, Instance, Properties],
   call(F),
   ( list(Query) ->
        match_list(Query, Properties)
        ;
        match(Query, Properties) ).

%-------------------------------------------------
% add transitivity for certain frame/properties
% add frame/3 that gets a specific frame by its instance

% ?- find_frame(word, kind_of = life_form, orange).
% yes

% ?- find_frame(word, kind_of = life_form, X).
% X = orange ;
% X = tree ;
% X = plant ;
% no

% ?- find_frame(word, contains = tomatoes, X).
% X = pizza ;
% X = tomato_sauce ;
% no

