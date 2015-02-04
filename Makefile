REBAR = `which rebar`

all: deps compile

deps:
	@( $(REBAR) get-deps )

compile: clean
	@( $(REBAR) compile )

clean:
	@( $(REBAR) clean )

run:
	@( erl -boot start_sasl -config app.config -pa ebin deps/*/ebin -s gip )

.PHONY: all deps compile clean run