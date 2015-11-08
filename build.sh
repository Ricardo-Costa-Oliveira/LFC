#!/bin/sh
ocamllex lexer.mll && \
ocamlc -c lexer.ml && \
ocamlc -o FIXE lexer.cmo
