-module(getsearchperson_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-define(Url,"http://api.themoviedb.org/3").
-define(ApiKey,"12598c38af2f10ab6066499ccddba71d").

init(_Transport, Req, []) ->
    {ok, Req, undefined}.

handle(Req, State) ->
    inets:start(),
    {Search, Req2} = cowboy_req:binding(search, Req),
    {Page, Req3} = cowboy_req:binding(page, Req),
    SearchS = binary_to_list(Search),
    PageS = binary_to_list(Page),
    {ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} = httpc:request(get, {?Url ++ "/search/person?api_key=" ++ ?ApiKey ++ "&query=" ++ SearchS ++ "&page=" ++ PageS ++ "&include_adult=false", []}, [], []),
    {ok, Req4} = cowboy_req:reply(200, [], unicode:characters_to_binary(Body, utf8), Req),
    {ok, Req4, State}.

terminate(_Reason, _Req, _State) ->
    ok.