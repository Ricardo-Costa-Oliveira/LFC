(* header section *)

{
	open Printf

	let num_lines = ref 1
	let num_chars = ref 0

	let print_lexing_error st =
		printf "[%d,%d] %s \n" !num_lines !num_chars st

	(*
	   To make the generated automata small,
	   we have to encode using keyword table.
	   With this we avoid the following type of error
	   "camllex: transition table overflow, automaton is too big"
	*)
	let create_hastable size init = 
		let tbl = Hashtbl.create size in
		List.iter (fun (key, data) -> Hashtbl.add tbl key data ) init;

tbl
	type token = 
		(* selection-statement *)
		| IF
		| THEN
		(* jump-statement *)		
		| RETURN
		(* declaration *)
		| DEF

		| ASSIGN
		(* punctuation *)
		| SEMICOLON
		| COLON
		| COMMA
		| LPAREN
		| RPAREN
		| LBRACE
		| RBRACE
		| RBRACK
		| LBRACK
		| DOTDOT

		(* type-specifier *)
		| BOOL
		| INTEGER
		| VOID
		| STRUCT
		| UNSIGNED_BITS
		| VECTOR

		(* storage-class-specifier *)
		| TYPEDEF
		| REGISTER

		(* iteration-statement *)
		| SEQ
		| WHILE

		| MATRIX

		| BOOLEAN of bool
		| INT of int
		| ID of string
		| CHAR of char
		| BITS of string
		| OP of char

		| OR
		| CONCAT

		| TO
		| BY
		| OF
		

	let keyword_table = 
		create_hastable 20 [
		    ("if", IF);
		    ("then", THEN);
		    ("true", BOOLEAN true);
		    ("false", BOOLEAN false);
		    ("def", DEF);
		    ("return", RETURN);

		    ("void", VOID);
		    ("int", INTEGER);
		    ("struct", STRUCT);
		    ("bool", BOOL);

		    ("unsigned bits", UNSIGNED_BITS);
		    ("vector", VECTOR);
		    ("typedef", TYPEDEF);
		    ("register", REGISTER);

		    ("seq", SEQ);
		    ("while", WHILE);

		    ("matrix", MATRIX);

		    ("to", TO);
		    ("by", BY);
		    ("of", OF)

		    
		]



}
(* definitions section *)
	(* The definitions section contains declarations of
	   simple ident definitions to simplify the scanner
	   specification.
	*)
	let digit = ['0'-'9']
	let id = ['a'-'z' '_' 'A'-'Z'] ['a'-'z' '_' 'A'-'Z' '0'-'9']*
	let bits = ['0'-'1'] ['b'] ['0'-'1']+
	let newline = '\r' | '\n' | "\r\n"
	let white = [' ' '\t']+
	let frac = '.' digit*

(* rules section *)
	(* "longest match" principle *)

	rule fixe = parse (* If we want to select the shortest
			     prefix of the input, use shortest keyword
			     instead of the parse keyword.
			   *)
		| digit+ as inum (* integer number *)
			{ let num = int_of_string inum in
			  incr num_chars;
			  (*printf "integer: %s (%d)\n" inum num ;*)
			  INT num
			}
		| "unsigned bits" as word
			{ 
			let token = Hashtbl.find keyword_table word in
			  printf "keyword: %s\n" word;
			  token
			}
		| id as word
			{ try
			let token = Hashtbl.find keyword_table word in
			  printf "keyword: %s\n" word;
			  token
			  with Not_found ->
			    (* if not a keyword the is an identifier *)
			    printf "identifier %s\n" word;
			    ID word
			}
		| bits as bit
			{ incr num_chars;
			  BITS bit
			}
		| '+' as op
			{ (*printf "operator %c\n" op;*)
			  incr num_chars;
			  OP op
			} 
		| '-' as op
			{ (*printf "operator %c\n" op;*)
			  incr num_chars;
			  OP op
			} 
		| '*' as op
			{ (*printf "operator %c\n" op;*)
			  incr num_chars;
			  OP op
			} 
		| '/' as op
			{ (*printf "operator %c\n" op;*)
			  incr num_chars;
			  OP op
			}
		| '>' as op
			{ (*printf "operator %c\n" op;*)
			  incr num_chars;
			  OP op
			} 
		| '<' as op
			{ (*printf "operator %c\n" op;*)
			  incr num_chars;
			  OP op
			}
		| "||"
			{ (*printf "or %c\n" op;*)
			  incr num_chars;
			  OR
			}
		| '@'
			{ (*printf "concat %c\n" op;*)
			  incr num_chars;
			  CONCAT
			}
		| ":="
			{ (*printf "assign\n";*)
			  ASSIGN
			}
		| ';'
			{ (*printf "semicolon\n";*)
			  SEMICOLON
			}
		| ','
			{ (*printf "comma\n";*)
			  COMMA
			} 
		| ':'
			{ (*printf "colon\n";*)
			  COLON
			}
		| ".."
			{ (*printf "dotdot\n";*)
			  DOTDOT
			}  
		| '}'
			{ incr num_chars;
			  (*printf "rbrace\n";*)
			  RBRACE
			}
		| '{'
			{ incr num_chars;
			  (*printf "lbrace\n";*)
			  RBRACE
			}
		| '['
			{ incr num_chars;
			  (*printf "LBRACK\n";*)
			  LBRACK
			}
		| ']'
			{ incr num_chars;
			  (*printf "RBRACK\n";*)
			  RBRACK
			}
		| newline
			{ incr num_lines;
			  num_chars := 0;
			  fixe lexbuf
			}
		| [' ' '\t'] (* eat up whitespace *)
			{ incr num_chars;
			  fixe lexbuf
			}
		| '('
			{ (*printf "lparen \n";*)
			  incr num_chars;
			  LPAREN
			}
		| ')'
			{ (*printf "rparen \n";*)
			  incr num_chars;
			  RPAREN
			}

		(* When the generated scanner meets comment start token "(*"
		   at the token rule, it activates the other rule comment.
		*)
		| "(*" (* activate "comment" rule *)
			{ comment lexbuf
			}
		| "*)" (* unbalanced comments*)
			{ ( print_lexing_error "Unbalanced comments" );
			  incr num_chars;
			  fixe lexbuf
			}
		(* Any text not matched by a ocamllex scanner generates exception
		   Failure "lexing: empty token" , so we have to supply this last
		   two rules.
		*)

		| _ as c
			{ printf "[%d,%d] Unrecognized character %c \n" !num_lines !num_chars c;
			  CHAR c
			}
		| eof
			{ raise End_of_file }

		(* When it meets the end of comment token "*)" at the comment
		   rule. it returns to the scanning token rule.
		 *)

		and comment = parse
			| "*)" (* go to the "token" rule *)
				{ fixe lexbuf
				}
 			| [ '\n' ]
				{ incr num_lines;
				  incr num_chars;
				  comment lexbuf
				} 
			| _ (* skip comments *)
				{ incr num_chars;
				  comment lexbuf
				}
			| eof
				{ raise End_of_file }

(* trailer section *)

{
	
	let rec parse lexbuf =
		let token = fixe lexbuf in
		(* do nothing *)
		parse lexbuf

	let main () = 
		let cin =
			if Array.length Sys.argv > 1
			then open_in Sys.argv.(1)
			else stdin
		in
		let lexbuf = Lexing.from_channel cin in
		try parse lexbuf
		with End_of_file -> ()

	let _ = Printexc.print main()

	
	(*let token_list_of_string s =
		let lb = Lexing.from_string s in
		let rec helper l =
			try
				let t = fixe lb in
				helper (t::l)
			with _ -> List.rev l
		in 
			helper []*)
	
}
