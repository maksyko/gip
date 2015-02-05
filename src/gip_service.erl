-module(gip_service).
-export([get/1,request/2]).
-export([get_geo_data/1]).
-export([get_geo_coordinates/1]).


get_geo_data(Ip) when (is_binary(Ip) or is_list(Ip)) ->
  GeoData = get_geo_coordinates(Ip),
  GET = ?MODULE:get("http://maps.google.com/maps/api/geocode/json?latlng="++to_list(proplists:get_value(<<"lat">>, GeoData))++","++to_list(proplists:get_value(<<"lng">>, GeoData))++"&sensor=false"),
  {ok,{{"HTTP/1.1",200,"OK"}, _ResponseHeader, ResponseBody}} = GET,
  BodyList = jsx:decode(to_binary(ResponseBody)),
  [Components | _] = proplists:get_value(<<"results">>, BodyList),
  [Adr, Street, Street2 | _] = [ LongName  || [{<<"long_name">>,LongName} | _ ] <-proplists:get_value(<<"address_components">>, Components) ],
  lists:merge(GeoData,[{<<"address">>, Adr}, {<<"street">>, Street}, {<<"street2">>, Street2}]);
get_geo_data(_) -> {error, wrong_coordinates_data}.

get_geo_coordinates(Ip) when (is_binary(Ip) or is_list(Ip)) ->
  AddressInt = egeoip:ip2long(to_list(Ip)),
  prepare_geo_coordinates(AddressInt);
get_geo_coordinates(_) -> {error, wrong_format_data}.

prepare_geo_coordinates({ok,AddressInt}) ->
  {ok, {_, CountryCode,_CountryCode3, _CountryName, _Region, City, _Code, _Lat, _Lng,_,_}} =  egeoip:lookup(AddressInt),
  {ok, [
    {<<"country_code">>,to_binary(CountryCode)},
    {<<"city">>,City}
%%     {<<"country_code3">>,to_binary(CountryCode3)},
%%     {<<"country_name">>,to_binary(CountryName)},
%%     {<<"region">>,Region},
%%     {<<"code">>,Code},
%%     {<<"lat">>, Lat},
%%     {<<"lng">>, Lng}
  ]};
prepare_geo_coordinates(_) -> {error, wrong_format_data}.


to_list(L) when is_list(L)   -> L;
to_list(F) when is_float(F)  -> float_to_list(F,  [{decimals, 4}]);
to_list(B) when is_binary(B) -> binary_to_list(B).

to_binary(L) when is_list(L)   -> list_to_binary(L);
to_binary(B) when is_binary(B) -> B.

get(URL) -> request(get,  {URL, []}).
request(Method, Body) -> httpc:request(Method, Body, [], []).
