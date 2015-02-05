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

handle_call({google, IP}, _From, State) ->
  {reply, gip_service:get_geo_data(IP), State};
handle_call({coord, IP}, _From, State) ->
  {reply, gip_service:get_geo_coordinates(IP), State};
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