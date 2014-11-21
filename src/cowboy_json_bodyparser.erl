-module(cowboy_json_bodyparser).

-export([execute/2]).

-define(CASE(N),
  {ok, {<<"application">>, <<_:N/binary, "+json">>, _}, Req2} ->
    {incomplete, F} = jsxn:decode(<<>>, [stream]),
    stream(F, Req2, Env)
).

execute(Req, Env) ->
  case cowboy_req:has_body(Req) of
    false ->
      {ok, Req, Env};
    true ->
      is_json(Req, Env)
  end.

is_json(Req, Env) ->
  case cowboy_req:parse_header(<<"content-type">>, Req) of
    {ok, {<<"application">>, <<"json">>, _}, Req2} ->
      {incomplete, F} = jsxn:decode(<<>>, [stream]),
      stream(F, Req2, Env);
    ?CASE(1);
    ?CASE(2);
    ?CASE(3);
    ?CASE(4);
    ?CASE(5);
    ?CASE(6);
    ?CASE(7);
    ?CASE(8);
    ?CASE(9);
    ?CASE(10);
    ?CASE(11);
    ?CASE(12);
    ?CASE(13);
    ?CASE(14);
    ?CASE(15);
    ?CASE(16);
    ?CASE(17);
    ?CASE(18);
    ?CASE(19);
    ?CASE(20);
    ?CASE(21);
    ?CASE(22);
    ?CASE(23);
    ?CASE(24);
    ?CASE(25);
    ?CASE(26);
    ?CASE(27);
    ?CASE(28);
    ?CASE(29);
    ?CASE(30);
    ?CASE(31);
    ?CASE(32);
    {ok, _, Req2} ->
      {ok, Req2, Env}
  end.

stream(F, Req, Env) ->
  case cowboy_req:body(Req) of
    {ok, Data, Req2} ->
      {incomplete, G} = F(Data),
      end_stream(G, Req2, Env);
    {more, Data, Req2} ->
      {incomplete, G} = F(Data),
      stream(G, Req2, Env)
  end.

end_stream(F, Req, Env) ->
  case catch F(end_stream) of
    {'EXIT', _Error} ->
      %% TODO figure out an error handler
      {ok, Req2} = cowboy_req:reply(400, [
        {<<"content-type">>, <<"application/json">>}
      ], jsxn:encode(#{
        <<"error">> => #{

        }
      }), Req),
      {halt, Req2};
    Body ->
      Req2 = cowboy_req:set_meta(body, Body, Req),
      {ok, Req2, Env}
  end.
