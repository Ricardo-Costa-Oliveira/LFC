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
		| IF
		| THEN
		| ELSE
		| VECTOR
		| RETURN
		| DEF
		| INT of int
		| ID of string
		| CHAR of char
		| OP of char
		| ASSIGN of string
		

	let keyword_table = 
		create_hastable 8 [
		    ("if", IF);
		    ("then", THEN);
		    ("else", ELSE);
		    ("def", DEF);
		    ("return", RETURN);
		    ("vector", VECTOR)
		]



}
(* definitions section *)
	(* The definitions section contains declarations of
	   simple ident definitions to simplify the scanner
	   specification.
	*)
	let digit = ['0'-'9']
	let id = ['a'-'z' 'A'-'Z'] ['a'-'z' '0'-'9']*
	let newline = '\r' | '\n' | "\r\n"
	let white = [' ' '\t']+
	let frac = '.' digit*
	let exp = ['e' 'E'] ['-' '+']? digit+

(* rules section *)
	(* "longest match" principle *)

	rule fixe = parse (* If we want to select the shortest
			     prefix of the input, use shortest keyword
			     instead of the parse keyword.
			   *)
		| digit+ as inum (* integer number *)
			{ let num = int_of_string inum in
			  incr num_chars;
			  printf "integer: %s (%d)\n" inum num ;
			  INT num
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
		| '+' as op
			{ printf "operator %c\n" op;
			  incr num_chars;
			  OP op
			} 
		| '-' as op
			{ printf "operator %c\n" op;
			  incr num_chars;
			  OP op
			} 
		| '*' as op
			{ printf "operator %c\n" op;
			  incr num_chars;
			  OP op
			} 
		| '/' as op
			{ printf "operator %c\n" op;
			  incr num_chars;
			  OP op
			} 
		| ":=" as assign
			{ printf "[%d,%d] assign %s\n" !num_lines !num_chars assign;
			  ASSIGN assign
			  
			} 
		| [ '\n' ]
			{ incr num_lines;
			  incr num_chars;
			  fixe lexbuf
			} 
		| '{' [^ '\n']* '}' (* eat up one line comments *)(* ACHO QUE NAO CHEGA AQUI *)
		| [' ' '\t'] (* eat up whitespace *)
			{ incr num_chars;
			  fixe lexbuf
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
			{ ( print_lexing_error "Unrecognized character" );
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
	
}
