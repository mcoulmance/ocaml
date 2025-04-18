(* TEST *)

type t = ..

type t +=
  | A
  | B of int

let f = function
  | B x -> x
  | _ -> 0


let _ = f (Sys.opaque_identity A)
