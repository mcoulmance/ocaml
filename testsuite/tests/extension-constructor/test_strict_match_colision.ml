(* TEST *)


(* The purpose of this test is to check whether hash colision are handled
   correctly. The example of the colision comes from
   https://caml-list.inria.narkive.com/oQ1aVJEr/hash-clash-in-polymorphic-variants
*)

module M1 =
  struct
    type [@strict] t = ..

    type t += NSaServ | SaupDOF

    let foo = function
      | NSaServ -> print_endline "NSaServ"
      | SaupDOF -> print_endline "SaupDOF"
      | _ -> print_endline "unknown"
  end


module M2 =
  struct
    type [@strict] t = ..

    type t += NSaServ of int | SaupDOF

    let foo = function
      | NSaServ _ -> print_endline "NSaServ"
      | SaupDOF -> print_endline "SaupDOF"
      | _ -> print_endline "unknown"
  end


module M3 =
  struct
    type [@strict] t = ..

    type t += NSaServ of int | SaupDOF of bool

    let foo = function
      | NSaServ _ -> print_endline "NSaServ"
      | SaupDOF _ -> print_endline "SaupDOF"
      | _ -> print_endline "unknown"
  end


module M4 =
  struct
    type [@strict] t = ..

    type t += NSaServ

    let foo = function
      | NSaServ -> print_endline "NSaServ"
      | _ -> print_endline "unknown"

    type t += SaupDOF
  end


module M5 =
  struct
    type [@strict] t = ..

    type t += NSaServ of int

    let foo = function
      | NSaServ _ -> print_endline "NSaServ"
      | _ -> print_endline "unknown"

    type t += SaupDOF
  end

module M6 =
  struct
    type [@strict] t = ..

    type t += NSaServ of int

    let foo = function
      | NSaServ _ -> print_endline "NSaServ"
      | _ -> print_endline "unknown"

    type t += SaupDOF of bool
  end


let _ =
  M1.(
    foo NSaServ;
    foo SaupDOF
  );
  M2.(
    foo (NSaServ 42);
    foo SaupDOF
  );
  M3.(
    foo (NSaServ 42);
    foo (SaupDOF true)
  );
  M4.(
    foo NSaServ;
    foo SaupDOF
  );
  M5.(
    foo (NSaServ 42);
    foo SaupDOF
  );
  M6.(
    foo (NSaServ 42);
    foo (SaupDOF true)
  )
