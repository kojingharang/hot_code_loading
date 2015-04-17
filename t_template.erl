-module(t_template).

-export([
         a/1, b/1, c0/2, ca/1, cb/1, cc/1, cd/1, d/3,
         x/1, y/1
        ]).

%% To ensure function body is explicitly different!
-define(BOO,     timer:sleep(__THE_NUMBER__)).

p(V) ->
    io:format("~p~n", [V]).

%% Return stack trace list.
stacktrace() ->
    Trace = try throw(42) catch 42 -> erlang:get_stacktrace() end,
    [ lists:flatten(io_lib:format("~p:~p/~p", [M, F, Arity])) || {M, F, Arity, _} <- Trace ].

%% Reload this module.
reload(I) ->
    %% Force update beam (ugly..)
    case I rem 2 of
        0 -> file:copy("t0.beam", "t.beam");
        1 -> file:copy("t1.beam", "t.beam")
    end,
    code:purge(t),
    {module, t} = code:load_file(t).

a(0) -> ok;
a(I) ->
    ?BOO,
    p({"a() - fully qualified call -> OK", I, stacktrace()}),
    reload(I),
    t:a(I-1).

b(0) -> ok;
b(I) ->
    ?BOO,
    p({"b() - not fully qualified call -> death", I, stacktrace()}),
    reload(I),
    b(I-1).

c0(_, 0) -> ok;
c0(Fun, I) ->
    ?BOO,
    p({"c0() - call Fun -> OK if Fun is fully qualified", I, stacktrace()}),
    reload(I),
    Fun(Fun, I-1).

c1(_, 0) -> ok;
c1(Fun, I) ->
    ?BOO,
    p({"c1() [Not exported] -  call Fun -> OK if Fun is fully qualified", I, stacktrace()}),
    reload(I),
    Fun(Fun, I-1).

ca(I) ->
    p("ca() - pass fully qualified fun to c0 -> OK"),
    t:c0(fun t:c0/2, I).

cb(I) ->
    p("cb() - pass not fully qualified exported fun to c0 -> death"),
    c0(fun c0/2, I).

cc(I) ->
    p("cc() - pass anonymous fun to c1 -> death"),
    F = fun(F, I0) ->
                ?BOO,
                c1(F, I0)
        end,
    c1(F, I).

cd(I) ->
    p("cd() - pass not fully qualified not exported fun to c1 -> death"),
    c1(fun c1/2, I).

d(_, _, 0) -> ok;
d(Mod, Fun, I) ->
    p({"d() - fully qualified call -> OK", I, stacktrace()}),
    reload(I),
    apply(Mod, Fun, [Mod, Fun, I-1]).

x(I) ->
    p("x() - will call a, consume no stack frame -> OK"),
    t:a(I).

y(I) ->
    p("y() - will call a, consume a stack frame -> death"),
    t:a(I),
    p("some call").

