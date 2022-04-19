.PHONY: all build clean fmt deps

all: build

build:
	dune build

clean:
	dune clean

fmt:
	-dune build @fmt --auto-promote

deps:
	dune external-lib-deps --missing @@default
