.PHONY: all build clean fmt deps

all: build

build:
	dune build

clean:
	dune clean

fmt:
	-dune fmt

deps:
	opam install . --deps-only
