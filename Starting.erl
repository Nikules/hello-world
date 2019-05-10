-module(project).



-export([last1/1]).
-export([last2/1]).
-export([element_at/2]).
-export([len/1]).
-export([reverse/1]).
-export([is_palindrome/1]).
-export([compress/1]).



last1([Answer]) -> Answer;
last1([H|T]) 	-> last1(T).



last2([Answer1, Answer2]) 	-> {Answer1, Answer2};
last2([H|T]) 			-> last2(T).



element_at([H|T], 1) 	-> H;
element_at([H|T], N) 	-> element_at(T, N - 1).



len([]) 		-> 0;
len([_]) 		-> 1;
len(List) 		-> len(List, 0).
len([], N) 		-> N;
len([H|T], N) 		-> len(T, N + 1).



reverse(Numbers) 	-> reverse(Numbers, []).
reverse([], Acc) 	-> Acc;
reverse([H|T], Acc) 	-> reverse(T, [H|Acc]).



is_palindrome(L)	->
	reverse(L) =:= L.



compress(List)					-> compress(List, [], []).
compress([], Acc1, Acc2)			-> reverse(Acc2);
compress([H|T], Acc1, Acc2) when Acc2 == []	-> compress(T, [H|Acc1], [H|Acc2]);
compress([H|T], Acc1, Acc2)			->
	if [H] == Acc1 -> compress(T, [H], Acc2);
		[H] =/= Acc1 -> compress(T, [H], [H|Acc2])
	end.
