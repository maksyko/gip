-module(gip).

%% API
-export([
  start/0,
  stop/0
]).

start() ->
  application:start(crypto),
  application:start(asn1),
  application:start(public_key),
  application:start(ssl),
  application:start(sasl),
  application:start(inets),
  application:start(compiler),
  application:start(syntax_tools),
  application:start(egeoip),
  application:start(lager),
  application:start(gip),
  ok.
stop() ->
  application:stop(?MODULE).
