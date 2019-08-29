-module(bin).

-export([first_word/1]).
-export([words/1]).
-export([split/2]).
-export([decode/2]).
-export([json/0]).


first_word(Bin) -> first_word(Bin, <<>>).

first_word(Bin, Acc) ->
    <<Symbol, Rest/binary>> = Bin,
    case Symbol of
        32 -> Acc;
        _ -> first_word(Rest, <<Acc/binary, Symbol>>)
    end.

words(Bin) -> words(Bin, [], <<>>).

words(<<>>, Acc1, Acc2) ->
    lists:reverse([Acc2|Acc1]);
words(Bin, Acc1, Acc2) -> <<Symbol, Rest/binary>> = Bin,
    case Symbol of
        32 -> words(Rest, [Acc2|Acc1], <<>>);
        _-> words(Rest, Acc1, <<Acc2/binary, Symbol>>)
    end.

split(Bin, Patern) ->
    split(Bin, Patern, <<>>, []).

split(<<>>, _Patern, Acc1, Acc2) ->
    lists:reverse([Acc1|Acc2]);
split(Bin, Patern, Acc1, Acc2) ->
    PatSize = sizeOfBin(Patern),
    BinSize = sizeOfBin(Bin),
        case BinSize > PatSize of
            true ->
                <<Symbol:PatSize/binary, Rest/binary>> = Bin,
                io:format("Symbol ~p~n", [Symbol]),
                case Symbol of
                    Patern ->
                        split(Rest, Patern, <<>>, [Acc1|Acc2]);
                    _ ->
                        <<A, Rest2/binary>> = Bin, split(Rest2, Patern, <<Acc1/binary, A>>, Acc2)
                end;
            false ->
                split(<<>>, Patern, <<Acc1/binary, Bin/binary>>, Acc2)
        end.

sizeOfBin(Bin) -> sizeOfBin(Bin, 0).

sizeOfBin(<<>>, Size) -> Size;
sizeOfBin(<<_El, Rest/binary>>, Size) -> sizeOfBin(Rest, Size + 1).


decode(Json, proplist) -> decode(Json, <<>>, []).

decode(<<>>, _Acc, Rez) ->
    lists:reverse(Rez);
%% verify, if Json is nested
decode(Json, <<>>, []) ->
    <<El1:1/binary, El2:1/binary, Rest/binary>> = Json,
    case El1 == <<123>> of
        true ->
            decode(Rest, El2, []);
        false ->
            decode(Rest, <<El1/binary, El2/binary>>, [])
    end;
%% cutting Json by comma and send cutted part to add key & value.
decode(Json, Acc, Rez) ->
	<<El:1/binary, Rest/binary>> = Json,
    case El of
        <<125>> ->
            decode(Rest, <<>>, [adder(<<Acc/binary, El/binary>>)|Rez]);%% }
        <<123>> ->
            decode(cuttjson(Rest), <<>>, [{addkey(Acc), decode(cuttjson(Rest), <<>>, [])}|Rez]);%% {
        <<91>> ->
            decode(cuttlist(Rest), <<>>, [{addkey(Acc), addlist(Rest)}|Rez]);%% [
	<<44>> ->
            decode(Rest, <<>>, [adder(<<Acc/binary, El/binary>>)|Rez]);%% ,
        _ ->
            decode(Rest, <<Acc/binary, El/binary>>, Rez)
	end.
%% adding key & value
adder(Json) -> adder(Json, <<>>, <<>>, <<>>).

adder(<<>>, Key, Val, _Acc) ->
    <<El:1/binary, _Rest/binary>> = Val,
    if
        El == <<39>> -> {Key, Val};
        Val == <<"true">> -> {Key, true};
        Val == <<"false">> -> {Key, false};
        true -> {Key, binary_to_integer(Val)}
    end;
adder(Json, Key, Val, Acc) ->
	<<El:1/binary, Rest/binary>> = Json,
	case El of
        <<39>> ->
            adder(Rest, Key, Val, Acc);%% ''
        <<32>> ->
            adder(Rest, Key, Val, Acc);%% space
        <<91>> ->
            {Key, addlist(Rest)};%% [
	<<58>> ->
            adder(Rest, <<Key/binary, Acc/binary>>, <<>>, <<>>);%% :
        <<44>> ->
            adder(Rest, Key, <<Val/binary, Acc/binary>>, <<>>);%% ,
		<<125>> ->
            adder(Rest, Key, <<Val/binary, Acc/binary>>, <<>>);%% }
		_->
            adder(Rest, Key, <<>>, <<Acc/binary, El/binary>>)
	end.

addlist(Json) -> addlist(Json, <<>>, []).

addlist(<<>>, _Acc, Rez) ->
    lists:reverse(Rez);
addlist(Json, Acc, Rez) ->
    <<El:1/binary, Rest/binary>> = Json,
    case El of
        <<32>> ->
            addlist(Rest, Acc, Rez);%% space
        <<44>> ->
            addlist(Rest, <<>>, [Acc|Rez]);%% ,
        <<93>> ->
            addlist(<<>>, <<>>, [Acc|Rez]); %% ]
        <<39>> ->
            addlist(Rest, Acc, Rez);%% ''
        <<123>> ->
            addlist(cuttjson(Rest), <<>>, [decode(addToJson(Rest), <<>>, [])|Rez]);%% {
        _ ->
            addlist(Rest, <<Acc/binary, El/binary>>, Rez)
    end.

cuttjson(Json) -> <<El:1/binary, Rest/binary>> = Json,
    case El of
        <<125>> ->
            <<_El2:1/binary, Rest2/binary>> = Rest, Rest2;%% }
        _ ->
            cuttjson(Rest)
    end.

addToJson(Json) -> addToJson(Json, <<>>).
addToJson(Json, Acc) -> <<El:1/binary, Rest/binary>> = Json,`
    case El of
        <<125>> -> <<Acc/binary, El/binary>>;
        _ -> addToJson(Rest, <<Acc/binary, El/binary>>)
    end.

cuttlist(Json) -> <<El:1/binary, Rest/binary>> = Json,
    case El of
        <<93>> ->
            <<_El1:1/binary, Rest1/binary>> = Rest, Rest1;%% ]
        _ ->
            cuttlist(Rest)
    end.

addkey(Json) -> addkey(Json, <<>>).

addkey(Json, Acc) -> <<El:1/binary, Rest/binary>> = Json,
    case El of
        <<58>> -> Acc;%% :
        <<32>> -> addkey(Rest, Acc);%% space
        <<39>> -> addkey(Rest, Acc);%% ''
        _ -> addkey(Rest, <<Acc/binary, El/binary>>)
    end.

json() ->
_Json = <<"{'key1':'val1', 'key2': 'val2', 'key3': [{'k3':'V3'},'v3', 'v3'], 'key4': {'k5':'v5'},'key5':'val5'}">>.
