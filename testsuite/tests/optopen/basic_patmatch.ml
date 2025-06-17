(* TEST
  flags = "-optopen";
  native;
  bytecode;
*)

type t = ..

type t += A | B

let foo x =
  match x with
    | A -> "A"
    | B -> "B"
    | _ -> "unknown"


type t += C of int | D of t


let rec bar x =
  match x with
    | C v -> Printf.sprintf "C(%d)" v
    | D v -> Printf.sprintf "D(%s)" (bar v)
    | e   -> foo x


type t += E

let foobar x =
  let s = bar x in
  print_endline s


let _ =
  foobar A;
  foobar B;
  foobar (C 42);
  foobar (D (C 42));
  foobar (D (D A));
  foobar (D (D (D (D (C 80)))));
  foobar E
