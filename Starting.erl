Now we`ve started.
-module(project).


-export([add/2]).
-export([reside/2]).
-export([last1/1]).
-export([last2/1]).
-export([element_at/2]).
-export([reverse/1]).

add(A, B) ->
A + B.


reside(A, B) ->
A - B.


last1([]) -> [];
last1([Ans]) -> Ans;
last1([H|T]) -> last1(T).


last2([]) -> [];
last2([Answer]) -> Answer;
last2([Answer1, Answer2]) -> {Answer1, Answer2};
last2([H|T]) -> last2(T).


element_at([], N) -> [];
element_at([H|T], N) when N >= 0 ->
if N == 1 -> H;
	N > 1 -> element_at(T, N - 1)
end.


reverse(Numbers) -> reverse(Numbers, []).
reverse([], Acc) -> Acc;
reverse([H|T], Acc) -> reverse(T, [H|Acc]).
