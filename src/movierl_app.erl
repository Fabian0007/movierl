-module(movierl_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-define(C_ACCEPTORS,  100).
%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    Routes    = routes(),
    Dispatch  = cowboy_router:compile(Routes),
    Port      = port(),
    TransOpts = [{port, Port}],
    ProtoOpts = [{env, [{dispatch, Dispatch}]}],
    {ok, _}   = cowboy:start_http(http, ?C_ACCEPTORS, TransOpts, ProtoOpts),
    movierl_sup:start_link().

stop(_State) ->
    ok.

%% ===================================================================
%% Internal functions
%% ===================================================================
routes() ->
    [
     {'_', [{"/movie/popular", getpopular_handler, []},
        {"/movie/:id", getmovie_handler, []},
        {"/person/:id", getperson_handler, []},
        {"/search/multi/:search/:page", getsearch_handler, []},
        {"/search/movie/:search/:page", getsearchperson_handler, []},
        {"/search/person/:search/:page", getsearchmovie_handler, []}
        ]}
    ].

port() ->
    case os:getenv("PORT") of
        false ->
            {ok, Port} = application:get_env(http_port),
            Port;
        Other ->
            list_to_integer(Other)
    end.