(* TEST
 expect;
*)

type [@strict] foo = ..
;;
[%%expect {|
type foo = .. [@@strict]
|}]

type foo = ..
[@@strict]
;;
[%%expect {|
type foo = .. [@@strict]
|}]

(* Check that abbreviation work *)

type bar = foo = ..
;;
[%%expect {|
Line 1, characters 0-19:
1 | type bar = foo = ..
    ^^^^^^^^^^^^^^^^^^^
Error: This variant or record definition does not match that of type "foo"
       [@strict] must be specified on both
|}]

type [@strict] baz = foo = ..
;;
[%%expect {|
type baz = foo = .. [@@strict]
|}]

type bar = foo = .. [@@strict]
;;
[%%expect {|
type bar = foo = .. [@@strict]
|}]

type bar += Bar1 of int
;;
[%%expect {|
type bar += Bar1 of int
|}]

type baz += Bar2 of int
;;
[%%expect {|
type baz += Bar2 of int
|}]

module M = struct type bar += Foo of float end
;;
[%%expect {|
module M : sig type bar += Foo of float end
|}]

module type S = sig type baz += Foo of float end
;;
[%%expect {|
module type S = sig type baz += Foo of float end
|}]

module M_S = (M : S)
;;
[%%expect {|
module M_S : S
|}]

(* Abbreviations need to be made open *)

type [@strict] foo = ..
;;
[%%expect {|
type foo = .. [@@strict]
|}]

type bar = foo
;;
[%%expect {|
type bar = foo
|}]

type bar += Bar of int
;;
[%%expect {|
Line 1, characters 0-22:
1 | type bar += Bar of int
    ^^^^^^^^^^^^^^^^^^^^^^
Error: Type definition "bar" is not extensible
|}]

type baz = bar = ..
;;
[%%expect {|
Line 1, characters 0-19:
1 | type baz = bar = ..
    ^^^^^^^^^^^^^^^^^^^
Error: This variant or record definition does not match that of type "bar"
       The original is abstract, but this is an extensible variant.
|}]

(* Check that annotation must appear on both the signature and the definition *)
module M : sig
  type t = ..
  [@@strict]
end = struct
  type t = ..
end
;;
[%%expect {|
Lines 4-6, characters 6-3:
4 | ......struct
5 |   type t = ..
6 | end
Error: Signature mismatch:
       Modules do not match:
         sig type t = .. end
       is not included in
         sig type t = .. [@@strict] end
       Type declarations do not match:
         type t = ..
       is not included in
         type t = .. [@@strict]
       [@strict] must be specified on both
|}]

module M : sig
  type t = ..
end = struct
  type t = ..
  [@@strict]
end
;;
[%%expect {|
Lines 3-6, characters 6-3:
3 | ......struct
4 |   type t = ..
5 |   [@@strict]
6 | end
Error: Signature mismatch:
       Modules do not match:
         sig type t = .. [@@strict] end
       is not included in
         sig type t = .. end
       Type declarations do not match:
         type t = .. [@@strict]
       is not included in
         type t = ..
       [@strict] must be specified on both
|}]

module M : sig
  type t = ..
  [@@strict]
end = struct
  type t = ..
  [@@strict]
end
;;
[%%expect {|
module M : sig type t = .. [@@strict] end
|}]

module M : sig
  type t = ..
end = struct
  type t = ..
end
;;
[%%expect {|
module M : sig type t = .. end
|}]

(* Check that rebinding is forbidden *)
type [@strict] t = ..
;;
[%%expect {|
type t = .. [@@strict]
|}]

type t += A
;;
[%%expect {|
type t += A
|}]

type t += C of int | D of char
;;
[%%expect {|
type t += C of int | D of char
|}]

type t += Z = A
;;
[%%expect {|
Line 1, characters 14-15:
1 | type t += Z = A
                  ^
Error: The type "t"
       is a strict open type. This means that constructor rebinding is forbidden when extending it.
|}]

type t += X of char | Y = D
;;
[%%expect {|
Line 1, characters 26-27:
1 | type t += X of char | Y = D
                              ^
Error: The type "t"
       is a strict open type. This means that constructor rebinding is forbidden when extending it.
|}]


module type M =
  sig
    type t = ..
    [@@strict]
  end
;;
[%%expect {|
module type M = sig type t = .. [@@strict] end
|}]

module F (X : M) =
  struct
    type X.t += A
    type X.t += B | C of int
  end
;;
[%%expect {|
module F : (X : M) -> sig type X.t += A type X.t += B | C of int  end
|}]

module F (X : M) =
  struct
    type X.t += A
    type X.t += B = A
  end
;;
[%%expect {|
Line 4, characters 20-21:
4 |     type X.t += B = A
                        ^
Error: The type "X.t"
       is a strict open type. This means that constructor rebinding is forbidden when extending it.
|}]
