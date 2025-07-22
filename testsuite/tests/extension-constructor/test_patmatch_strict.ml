(* TEST *)

module type S =
  sig
    type [@strict] t = ..
  end

module M : S =
  struct
    type t = ..
    [@@strict]
  end


module F (M : S) =
  struct
    type M.t +=
      | A
      | B
      | C of int
      | D of string
  end


module F1 = F(M)
module F2 = F(M)
module F3 = F(M)


let foo = function
  | F1.A -> print_endline "F1.A"
  | F1.B -> print_endline "F1.B"
  | F1.C x -> Printf.printf "F1.C(%d)\n" x
  | F1.D s -> Printf.printf "F1.D(%s)\n" s

  | F2.A -> print_endline "F2.A"
  | F2.B -> print_endline "F2.B"
  | F2.C x -> Printf.printf "F2.C(%d)\n" x
  | F2.D s -> Printf.printf "F2.D(%s)\n" s

  | _ -> print_endline "unknown"


let test name ctr =
  print_endline name;
  foo ctr


let _ =
  test "F1.A" F1.A;
  test "F1.B" F1.B;
  test "F1.C(42)" (F1.C 42);
  test "F1.D(hello)" (F1.D "hello");

  test "F2.A" F2.A;
  test "F2.B" F2.B;
  test "F2.C(77)" (F2.C 77);
  test "F2.D(goodbye)" (F2.D "goodbye");

  test "F3.A" F3.A;
  test "F3.B" F3.B;
  test "F3.C(19)" (F3.C 19);
  test "F3.D(error)" (F3.D "error")
