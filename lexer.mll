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
		let tbl = Hashtbl.create size in
		List.iter (fun (key, data) -> Hashtbl.add tbl key data ) init;
tbl
	type token = 
		| IF
		| THEN
		| ELSE
		| VECTOR
		| INT of int
		| ID of string
		| CHAR of char
		| OP of char
		| ASSIGN of string
		

	let keyword_table = 
		create_hastable 8 [
		    ("if", IF);
		    ("then", THEN);
		    ("vector", VECTOR)
		]
}
(* definitions section *)

	let digit = ['0'-'9']
	let id = ['a'-'z' 'A'-'Z'] ['a'-'z' '0'-'9']*

(* rules section *)

	rule fixe = parse 
		| digit+ as inum (* integer number *)
			{ let num = int_of_string inum in
			  printf "integer: %s (%d)\n" inum num;
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
		| '+'
		| '-'
		| '*'
		| '/' as op
			{ printf "operator %c\n" op;
			  OP op
			} 
		| ":=" as assign
			{ printf "assign %s\n" assign;
			  ASSIGN assign
			}     
		| '{' [^ '\n']* '}' (* eat up one line comments *)
		| [' ' '\t' '\n'] (* eat up whitespace *)
			{ fixe lexbuf }
		| _ as c
			{ printf "Unrecognized character %c\n" c;
			  CHAR c
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
