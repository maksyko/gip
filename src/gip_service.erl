-module(gip_service).
-export([get/1,request/2]).
-export([get_geo_coordinates/1]).


get_geo_coordinates(Ip) when (is_binary(Ip) or is_list(Ip)) ->
  AddressInt = egeoip:ip2long(to_list(Ip)),
  prepare_geo_coordinates(AddressInt);
get_geo_coordinates(_) -> {error, wrong_format_data}.

prepare_geo_coordinates({ok,AddressInt}) ->
  {ok, {_, CountryCode,_CountryCode3, _CountryName, _Region, City, _Code, _Lat, _Lng,_,_}} =  egeoip:lookup(AddressInt),
  {ok, [to_list(CountryCode), to_list(City)]};
prepare_geo_coordinates(_) -> {error, wrong_format_data}.


to_list(L) when is_list(L)   -> L;
to_list(F) when is_float(F)  -> float_to_list(F,  [{decimals, 4}]);
to_list(B) when is_binary(B) -> binary_to_list(B).

get(URL) -> request(get,  {URL, []}).
request(Method, Body) -> httpc:request(Method, Body, [], []).
