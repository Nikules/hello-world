-module(list).

-export([last/1]).
-export([but_last/1]).
-export([element_at/2]).
-export([len/1]).
-export([reverse/1]).
-export([is_palindrome/1]).
-export([flatten/1]).
-export([compress/1]).
-export([pack/1]).
-export([encode/1]).
-export([encode_modified/1]).
-export([decode_modified/1]).
-export([dublicate/1]).
-export([replicate/2]).

last([Element]) -> Element;
last([_|T]) -> last(T).

but_last([Element1, Element2]) -> {Element1, Element2};
but_last([_|T]) -> but_last(T).

element_at([H|_], 1) ->
    H;
element_at([_H|T], N) ->
    element_at(T, N - 1).

len(List) -> len(List, _N = 1).

len([], N) -> N;
len([_H|T], N) -> len(T, N + 1).

reverse(List) -> reverse(List, []).

reverse([], Acc) -> Acc;
reverse([H|T], Acc) -> reverse(T, [H|Acc]).

is_palindrome(List) ->
    reverse(List) =:= List.

flatten(List) ->
    flatten(List, []).

flatten([], Acc) ->
    lists:reverse(Acc);
flatten([[H|[]]|T], Acc) ->
    flatten(T, [H|Acc]);
flatten([[H1|T1]|T], Acc) ->
    flatten(flatten([T1|T]), [H1|Acc]);
flatten([H|T], Acc) ->
    flatten(T, [H|Acc]).

compress(List) ->
    compress(List, [], []).

compress([], _Acc1, Acc2) ->
    reverse(Acc2);
compress([H|T], Acc1 = [], Acc2 = []) ->
    compress(T, [H|Acc1], [H|Acc2]);
compress([H|T], [H], Acc2) ->
    compress(T, [H], Acc2);
compress([H|T], _Acc1, Acc2) ->
    compress(T, [H], [H|Acc2]).

pack(List) -> pack(List, [], [], []).

pack([], _Acc1, Acc2, Acc3) ->
    reverse([Acc2|Acc3]);
pack([H|T], [] = Acc1, Acc2, Acc3) ->
    pack(T, [H|Acc1], [H|Acc2], Acc3);
pack([H|T], _Acc1 = [H], Acc2, Acc3) ->
    pack(T, [H], [H|Acc2], Acc3);
pack([H|T], _Acc1, Acc2, Acc3) ->
    pack(T, [H], [H], [Acc2|Acc3]).

encode(List) -> encode(List, [], [], 1).

encode([], _Acc1, Acc2, _N) ->
    reverse(Acc2);
encode([H|T], [] = Acc1, [] = Acc2, 1) ->
    encode(T, [H|Acc1], Acc2, 1);
encode([H], [H|[]], Acc2, N) ->
    encode([], H, [{H, N + 1}|Acc2], N);
encode([H|T], [H], Acc2, N) ->
    encode(T, [H], Acc2, N + 1);
encode([H|T], [H1|_], Acc2, N) ->
    encode(T, [H], [{H1, N}|Acc2], 1).

encode_modified(List) -> encode_modified(List, [], [], 1).

encode_modified([], _Acc1, Acc2, _N) ->
    reverse(Acc2);
encode_modified([H|T], [] = Acc1, [] = Acc2, 1) ->
    encode_modified(T, [H|Acc1], Acc2, 1);
encode_modified([H], [H|[]], Acc2, N) ->
    encode_modified([], H, [{H, N + 1}|Acc2], N);
encode_modified([H|T], [H], Acc2, N) ->
    encode_modified(T, [H], Acc2, N + 1);
encode_modified([H|T], [H1|_], Acc2, 1) ->
    encode_modified(T, [H], [H1|Acc2], 1);
encode_modified([H|T], [H1|_], Acc2, N) ->
    encode_modified(T, [H], [{H1, N}|Acc2], 1).

decode_modified(List) -> decode_modified(List, []).

decode_modified([], Acc) ->
    reverse(Acc);
decode_modified([{El, 1} = _H|T], Acc) ->
    decode_modified(T, [El|Acc]);
decode_modified([{El, N} = _H|T], Acc) ->
    decode_modified([{El, N - 1}|T], [El|Acc]);
decode_modified([H|T], Acc) ->
    decode_modified(T, [H|Acc]).

dublicate(List) -> dublicate(List, [], _N = 2).

dublicate([], Acc, _) -> reverse(Acc);
dublicate([H|T], Acc, 1) -> dublicate(T, [H|Acc], 2);
dublicate([H|T], Acc, N) -> dublicate([H|T], [H|Acc], N - 1).

replicate(List, N) ->  replicate(List, N,Counter = 0, []).

replicate([], N, Counter, Acc) ->
    lists:reverse(Acc);
replicate([H|T], 1, 0, Acc) ->
    replicate(T, 1, 0, [H|Acc]);
replicate([H|T], N, Counter = 0, Acc) ->
    replicate([H|T], N - 1, Counter + 1, [H|Acc]);
replicate([H|T], 0, Counter, Acc) ->
    replicate(T, Counter, 0, Acc);
replicate([H|T], N, Counter, Acc) ->
    replicate([H|T], N - 1, Counter + 1, [H|Acc]).
