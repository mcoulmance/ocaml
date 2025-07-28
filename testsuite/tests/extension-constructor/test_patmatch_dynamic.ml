(* TEST *)


type t = ..
;;

type t +=
  | A
  | B
  | C of int
  | D of float
  | E of t * int
;;

let rec foo x =
  match x with
  | A [@dynamic] -> "A"
  | B -> "B"
  | C i -> Printf.sprintf "C(%d)" i
  | D f -> Printf.sprintf "D(%f)" f
  | E (t, i) -> Printf.sprintf "E(%s, %d)" (foo t) i
  | _ -> "unknown"
;;

let _ =
  print_endline "A";
  print_endline (foo A);
  print_endline "B";
  print_endline (foo B);
  print_endline "C(42)";
  print_endline (foo (C 42));
  print_endline "D(3.14)";
  print_endline (foo (D 3.14));
  print_endline "E(A, 2)";
  print_endline (foo (E (A, 2)));
  print_endline "E(E(E(C 42, 43), 44), 19)";
  print_endline (foo (E(E(E(C 42, 43), 44), 19)))
;;

module M =
  struct
    type t +=
      | A
      | B
      | C of int
      | D of float
      | E of t * int

    module J =
      struct
        type t +=
          | A
          | B
          | C of int
          | D of float
          | E of t * int
      end

    let rec foo' x =
      match x with
      | A [@dynamic] -> "M.A"
      | B -> "M.B"
      | C i -> Printf.sprintf "M.C(%d)" i
      | D f -> Printf.sprintf "M.D(%f)" f
      | E (t, i) -> Printf.sprintf "M.E(%s, %d)" (foo' t) i

      | J.A -> "M.J.A"
      | J.B -> "M.J.B"
      | J.C i -> Printf.sprintf "M.J.C(%d)" i
      | J.D f -> Printf.sprintf "M.J.D(%f)" f
      | J.E (t, i) -> Printf.sprintf "M.J.E(%s, %d)" (foo' t) i
      | e -> foo e
  end
;;

let rec foo2 x =
  match x with
  | M.A [@dynamic] -> "M.A"
  | M.B -> "M.B"
  | M.C i -> Printf.sprintf "M.C(%d)" i
  | M.D f -> Printf.sprintf "M.D(%f)" f
  | M.E (t, i) -> Printf.sprintf "M.E(%s, %d)" (foo2 t) i

  | M.J.A -> "M.J.A"
  | M.J.B -> "M.J.B"
  | M.J.C i -> Printf.sprintf "M.J.C(%d)" i
  | M.J.D f -> Printf.sprintf "M.J.D(%f)" f
  | M.J.E (t, i) -> Printf.sprintf "M.J.E(%s, %d)" (foo2 t) i
  | e -> foo e
;;

let _ =
  print_endline "#1";
  print_endline "A";
  print_endline (foo2 A);
  print_endline "B";
  print_endline (foo2 B);
  print_endline "C(42)";
  print_endline (foo2 (C 42));
  print_endline "D(3.14)";
  print_endline (foo2 (D 3.14));
  print_endline "E(A, 2)";
  print_endline (foo2 (E (A, 2)));
  print_endline "E(E(E(C 42, 43), 44), 19)";
  print_endline (foo2 (E(E(E(C 42, 43), 44), 19)));

  print_endline "#2";
  print_endline "M.A";
  print_endline (M.foo' M.A);
  print_endline "M.B";
  print_endline (M.foo' M.B);
  print_endline "M.C(42)";
  print_endline (M.foo' (M.C 42));
  print_endline "M.D(3.14)";
  print_endline (M.foo' (M.D 3.14));
  print_endline "M.E(M.A, 2)";
  print_endline (M.foo' (M.E (M.A, 2)));
  print_endline "M.E(M.E(E(unknown, 43), 44), 19)";
  print_endline (M.foo' (M.E(M.E(E(M.C 42, 43), 44), 19)));

  print_endline "#3";
  print_endline "M.A";
  print_endline (foo2 M.A);
  print_endline "M.B";
  print_endline (foo2 M.B);
  print_endline "M.C(42)";
  print_endline (foo2 (M.C 42));
  print_endline "M.D(3.14)";
  print_endline (foo2 (M.D 3.14));
  print_endline "M.E(M.A, 2)";
  print_endline (foo2 (M.E (M.A, 2)));
  print_endline "M.E(M.E(E(M.C 42, 43), 44), 19)";
  print_endline (foo2 (M.E(M.E(E(M.C 42, 43), 44), 19)));

  print_endline "#4";
  print_endline "M.J.A";
  print_endline (foo2 M.J.A);
  print_endline "M.J.B";
  print_endline (foo2 M.J.B);
  print_endline "M.J.C(42)";
  print_endline (foo2 (M.J.C 42));
  print_endline "M.J.D(3.14)";
  print_endline (foo2 (M.J.D 3.14));
  print_endline "M.J.E(M.A, 2)";
  print_endline (foo2 (M.J.E (M.A, 2)));
  print_endline "M.E(E(unknown, 19)";
  print_endline (foo2 (M.E(E(M.J.E(M.C 42, 43), 44), 19)))
;;


module type S =
  sig
    type t += A | B of int
  end
;;

module M1 : S =
  struct
    type t += A | B of int
  end


module F (M : S) =
  struct
    type t += A = M.A | B = M.B | C | D of int
  end
;;


module F1 = F(M1)
module F2 = F(M1)


let foo3 x =
  match x with
  | F1.A [@dynamic] -> "F1.A"
  | F1.B i -> Printf.sprintf "F1.B(%d)" i
  | F1.C -> "F1.C"
  | F1.D i -> Printf.sprintf "F1.D(%d)" i

  | F2.A -> "F2.A"
  | F2.B i -> Printf.sprintf "F2.B(%d)" i
  | F2.C -> "F2.C"
  | F2.D i -> Printf.sprintf "F2.D(%d)" i

  | e -> foo2 e


let _ =
  print_endline "#5";
  print_endline "M1.A (rebinded by F1.A)";
  print_endline (foo3 M1.A);
  print_endline "M1.B(42) (rebinded by F2.B)";
  print_endline (foo3 (M1.B 42));

  print_endline "#6";
  print_endline "F1.A";
  print_endline (foo3 (F1.A));
  print_endline "F1.B(18)";
  print_endline (foo3 (F1.B 18));
  print_endline "F1.C";
  print_endline (foo3 F1.C);
  print_endline "F1.D(89)";
  print_endline (foo3 (F1.D 89));

  print_endline "#7";
  print_endline "F2.A (rebinded by F1.A)";
  print_endline (foo3 (F2.A));
  print_endline "F2.B(18) (rebinded by F1.B)";
  print_endline (foo3 (F2.B 18));
  print_endline "F2.C";
  print_endline (foo3 F2.C);
  print_endline "F2.D(89)";
  print_endline (foo3 (F2.D 89));
