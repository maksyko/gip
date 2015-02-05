-module(gip_sup).
-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).


start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  Flags = {one_for_one, 5, 10},
  GipWorker = {gip_worker, {gip_worker, start_link,[]}, permanent, 2000, worker,[gip_worker]},
  {ok, { Flags , [GipWorker]} }.

