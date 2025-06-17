(* TEST
  flags = "-optopen";
  native;
  bytecode;
*)

type t = ..

type t += A | B of int

type t += C = A


let foo x =
  match x with 
    | A -> print_endline "A"
    | B v -> Printf.printf "B(%d)\n" v
    | C -> print_endline "C"
    | _ -> print_endline "unknown"

let _ =
  foo A;
  foo (B 42);
  foo C


let foo x =
  match x with 
    | C -> print_endline "C"
    | B v -> Printf.printf "B(%d)\n" v
    | A -> print_endline "A"
    | _ -> print_endline "unknown"

let _ =
  foo A;
  foo (B 42);
  foo C


type t += X = B

let foo x =
  match x with 
    | X v -> Printf.printf "X(%d)\n" v
    | _ -> print_endline "unknown"

let _ =
  foo (X 42);
  foo (B 42);
  foo A
