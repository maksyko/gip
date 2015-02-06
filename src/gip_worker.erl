-module(gip_worker).
-behaviour(gen_server).
-export([start_link/0]).
-export([
  init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3
]).
-export([get_geo_coordinates/1]).
-export([prepare_geo_coordinates/2]).

-define(SERVER, ?MODULE).
-define(LOG_INFO(Format, Data), lager:log(info, [], "~p.erl:~p: " ++ Format ++ "~n~n", [?MODULE, ?LINE] ++ Data)).
-record(state, {}).

%% =====================================================================================================================
get_geo_coordinates(IP) -> prepare_geo_coordinates(coord, IP).
%% =====================================================================================================================
prepare_geo_coordinates(Type, IP) ->
  try
    gen_server:call(?MODULE, {Type, IP})
  catch
    _:Error -> {error, Error}
  end.
%% =====================================================================================================================
start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
  {ok, #state{}}.

handle_call({coord, IP}, _From, State) ->
  {ExecutTime, GetGeoCoordinates} = timer:tc(gip_service, get_geo_coordinates, [IP]),
  ?LOG_INFO("get_geo_coordinates | input parameter | ~p ExecutTime ~p ms~n",[IP, ExecutTime/1000]),
  {reply, GetGeoCoordinates , State};
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
