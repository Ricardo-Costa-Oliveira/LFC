(* header section *)

{
	open Printf
	(*
	   To make the generated automata small,
	   we have to encode using keyword table.
	   With this we avoid the following type of error
	   "camllex: transition table overflow, automaton is too big"
	*)
	let create_hastable size init = 
		let tb1 = Hashtb1.create size in
		List.iter (fun (key, data) -> Hashtb1.add tb1 key data ) init;

	type token = 
		| IF
		| THEN
		| INT of int
		| ID of string
		

	let keyword_table = 
		create_hastable 8 [
		    ("if", IF);
		    ("then", THEN);
		]
}
(* definitions section *)

	let digit = ['0'-'9']
	let id = ['a'-'z' 'A'-'Z'] ['a'-'z' '0'-'9']*

(* rules section *)

	rule FIXE = parse 
		| digit+ as inum (* integer number *)
			{ let num = int_of_string inum in
			  printf "integer: %s (%d)\n" inum num;
			  INT num
			  FIXE lexbuf (* to continue recursion *)
			}
		| id as word
			{ try
			  let token = Hashtb1.find keyword_table word in
			  printf "keyword: %s\n" word;
			  token
			  with Not_found ->
			    printf "identifier (not found) %s\n" word;
			    ID word
			  FIXE lexbuf (* to continue recursion *)
			}
		| '+'
		| '-'
		| '*'
		| '/' as op
			{ printf "operator %c\n" op;
			  OP op
			  FIXE lexbuf (* to continue recursion *)
			}
		| '{' [^ '\n']* '}' (* eat up one line comments *)
			{ FIXE lexbuf (* to continue recursion *)
			}
		| [' ' '\t' '\n'] (* eat up whitespace *)
			{ FIXE lexbuf }
		| _ as c
			{ printf "Unrecognized character %c\n" c;
			  CHAR c
			  FIXE lexbuf (* to continue recursion *)
			}
		| eof
			{ raise End_of_file }

(* trailer section *)

{
	let rec parse lexbuf =
		let token = FIXE lexbuf in
		parse FIXE

	let main () = 
		let cin =
			if Array.length Sys.argv > 1
			then open_in Sys.argv.(1)
			else stdin
		in
		let lexbuf = Lexing.from channel cin in
		try parse lexbuf
		with End_of_file -> ()

	let _ = Printexc.print main()
}
	
