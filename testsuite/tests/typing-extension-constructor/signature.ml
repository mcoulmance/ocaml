(* TEST
   expect;
*)

module type S1 =
  sig
    type t = ..
    type t += A | B
    type t += C = A
  end
;;

[%%expect{|
module type S1 = sig type t = .. type t += A | B type t += C = A end
|}];;

module M1 : S1 =
  struct
    type t = ..
    type t += A | B | C
  end
;;

[%%expect{|
Lines 2-5, characters 2-5:
2 | ..struct
3 |     type t = ..
4 |     type t += A | B | C
5 |   end
Error: Signature mismatch:
       Modules do not match:
         sig type t = .. type t += A | B | C  end
       is not included in
         S1
       Extension declarations do not match:
         type t += C
       is not included in
         type t += C = A
       Constructors do not match:
         "C"
       is not the same as:
         "C = A"
       The first is declared as a rebinding for A, but the second is not.
|}];;

module M2 : S1 =
  struct
    type t = ..
    type t += A | B
    type t += C = B
  end
;;

[%%expect{|
Lines 2-6, characters 2-5:
2 | ..struct
3 |     type t = ..
4 |     type t += A | B
5 |     type t += C = B
6 |   end
Error: Signature mismatch:
       Modules do not match:
         sig type t = .. type t += A | B type t += C = B end
       is not included in
         S1
       Extension declarations do not match:
         type t += C = B
       is not included in
         type t += C = A
       Constructors do not match:
         "C = B"
       is not the same as:
         "C = A"
       the first is declared as a rebinding of B, but the second is declared as a rebinding for A
|}];;

module M3 : S1 =
  struct
    type t = ..
    type t += A | B
    type t += C = A
  end
;;

[%%expect{|
module M3 : S1
|}];;


module type S2 =
  sig
    type t = ..
    type t += A | B | C
  end
;;

[%%expect{|
module type S2 = sig type t = .. type t += A | B | C  end
|}];;

module M1 : S2 =
  struct
    type t = ..
    type t += A | B
    type t += C = A
  end
;;

[%%expect{|
module M1 : S2
|}];;
