PROJECT = cowboy_json_bodyparser

# dependencies

DEPS = jsxn jsx

dep_jsx = git https://github.com/talentdeficit/jsx develop
dep_jsxn = git https://github.com/talentdeficit/jsxn

include erlang.mk
