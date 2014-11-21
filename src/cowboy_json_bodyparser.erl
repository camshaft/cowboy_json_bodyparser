-module(cowboy_json_bodyparser).

-export([execute/2]).

execute(Req, Env) ->
  case cowboy_req:has_body(Req) of
    false ->
      {ok, Req, Env};
    true ->
      is_json(Req, Env)
  end.

is_json(Req, Env) ->
  case cowboy_req:parse_header(<<"content-type">>, Req) of
    {ok, {<<"application">>, <<"json", _/binary>>, _}, Req2} ->
      {incomplete, F} = jsxn:decode(<<>>, [stream]),
      stream(F, Req2, Env);
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
