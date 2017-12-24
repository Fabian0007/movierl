-module(getmovie_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-define(Url,"http://api.themoviedb.org/3").
-define(ApiKey,"12598c38af2f10ab6066499ccddba71d").

init(_Transport, Req, []) ->
    {ok, Req, undefined}.

handle(Req, State) ->
    inets:start(),
    {Id, Req2} = cowboy_req:binding(id, Req),
    Ids = binary_to_list(Id),
    {ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} = httpc:request(get, {?Url ++ "/movie/" ++ Ids ++ "d?api_key=" ++ ?ApiKey ++ "&append_to_response=alternative_titles,credits,releases,videos,similar,reviews,images", []}, [], []),
    {ok, Req3} = cowboy_req:reply(200, [], unicode:characters_to_binary(Body, utf8), Req),
    {ok, Req3, State}.

terminate(_Reason, _Req, _State) ->
    ok.