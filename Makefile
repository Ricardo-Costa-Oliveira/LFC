############
OCAMLC=/usr/bin/env ocamlc
OCAMLC_FLAGS= 
OCAMLLEX=/usr/bin/env ocamllex
OCAMLYACC=/usr/bin/env ocamlyacc
############
all: fixe

parser.ml: parser.mly
	$(OCAMLYACC) $<

lexer.ml: lexer.mll
	$(OCAMLLEX) $<

fixe: lexer.ml
	$(OCAMLC) $(OCAMLC_FLAGS) -o $@ lexer.ml

############
clean:
	rm -f lexer.ml
	rm -f lexer.cmo
	rm -f lexer.cmi
	rm -f fixe
	rm -f fixe.cmi
	rm -f fixe.cmo
