PROJECT = cowboy_json_bodyparser

# dependencies

DEPS = 

include erlang.mk

repl: all bin/start
	@bin/start cowboy_json_bodyparser

bin/start:
	@mkdir -p bin
	@curl https://gist.githubusercontent.com/camshaft/372cc332241ac95ae335/raw/start -o $@
	@chmod a+x $@

.PHONY: repl
