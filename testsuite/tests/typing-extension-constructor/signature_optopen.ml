(* TEST
   expect;
*)

module type S1 =
  sig
    type [@optopen] t = ..
    type t += A | B
    type t += C = A
  end
;;

[%%expect{|
module type S1 =
  sig type [@optopen] t = .. type t += A | B type t += C = A end
|}];;


module M1 : S1 =
  struct
    type t = ..
    type t += A | B
    type t += C = A
  end
;;

[%%expect{|
Lines 2-6, characters 2-5:
2 | ..struct
3 |     type t = ..
4 |     type t += A | B
5 |     type t += C = A
6 |   end
Error: Signature mismatch:
       Modules do not match:
         sig type t = .. type t += A | B type t += C = A end
       is not included in
         S1
       Type declarations do not match:
         type t = ..
       is not included in
         type [@optopen] t = ..
       Type annotation [@optopen] must be specified in both the interface and the implementation
|}];;

module M2 : S1 =
  struct
    type [@optopen] t = ..
    type t += A | B | C
  end
;;

[%%expect{|
Lines 2-5, characters 2-5:
2 | ..struct
3 |     type [@optopen] t = ..
4 |     type t += A | B | C
5 |   end
Error: Signature mismatch:
       Modules do not match:
         sig type [@optopen] t = .. type t += A | B | C  end
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

module M3 : S1 =
  struct
    type [@optopen] t = ..
    type t += A
    type t += B
    type t += C = A
  end
;;

[%%expect{|
module M3 : S1
|}];;


module type S2 =
  sig
    type [@optopen] t = ..
    type t += A | B | C
  end
;;

[%%expect{|
module type S2 = sig type [@optopen] t = .. type t += A | B | C  end
|}];;


module M1 : S2 =
  struct
    type [@optopen] t = ..
    type t += A | B
    type t += C = A
  end
;;

[%%expect{|
Lines 2-6, characters 2-5:
2 | ..struct
3 |     type [@optopen] t = ..
4 |     type t += A | B
5 |     type t += C = A
6 |   end
Error: Signature mismatch:
       Modules do not match:
         sig type [@optopen] t = .. type t += A | B type t += C = A end
       is not included in
         S2
       Extension declarations do not match:
         type t += C = A
       is not included in
         type t += C
       Constructors do not match:
         "C = A"
       is not the same as:
         "C"
       The second is declared as a rebinding for A, but the first is not.
Type t has been declared with [@optopen], so declaration must match in interface and implementation.
|}];;

module M2 : S2 =
  struct
    type t = ..
    [@@optopen]

    type t += A
    type t += B | C
  end
;;

[%%expect{|
module M2 : S2
|}];;


module type S3 =
  sig
    type t = ..
    type t += A | B | C
  end
;;

[%%expect{|
module type S3 = sig type t = .. type t += A | B | C  end
|}];;

module M1 : S3 =
  struct
    type [@optopen] t = ..
    type t += A | B | C
  end
;;

[%%expect{|
Lines 2-5, characters 2-5:
2 | ..struct
3 |     type [@optopen] t = ..
4 |     type t += A | B | C
5 |   end
Error: Signature mismatch:
       Modules do not match:
         sig type [@optopen] t = .. type t += A | B | C  end
       is not included in
         S3
       Type declarations do not match:
         type [@optopen] t = ..
       is not included in
         type t = ..
       Type annotation [@optopen] must be specified in both the interface and the implementation
|}];;
