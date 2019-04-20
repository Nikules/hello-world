-module(project).


-export([add/2]).
-export([reside/2]).
-export([last1/1]).
-export([last2/1]).
-export([element_at/2]).
-export([len/1]).
-export([reverse/1]).
-export([is_palindrome/1]).



add(A, B) ->
A + B.


reside(A, B) ->
A - B.


last1([]) 	-> {no_elements_in_list};
last1([Answer]) -> Answer;
last1([H|T]) 	-> last1(T).


last2([]) 			-> {no_elements_in_list};
last2([Answer]) 		-> Answer;
last2([Answer1, Answer2]) 	-> {Answer1, Answer2};
last2([H|T]) 			-> last2(T).


element_at([], N) 			-> [];
element_at([H|T], N) when N >= 0 	->
	if 	N == 1 	-> H;
		N > 1 	-> element_at(T, N - 1)
	end.


len([]) 		-> 0;
len([_]) 		-> 1;
len(List) 		-> len(List, 0).
len([], N) 		-> N;
len([H|T], N) 		-> len(T, N + 1).


reverse(Numbers) 	-> reverse(Numbers, []).
reverse([], Acc) 	-> Acc;
reverse([H|T], Acc) 	-> reverse(T, [H|Acc]).


is_palindrome(L) 	-> is_palindrome(L, reverse(L)).
is_palindrome(L, M) 	->
	if 	L == M -> {true};
		L =/= M -> {false}
	end.
