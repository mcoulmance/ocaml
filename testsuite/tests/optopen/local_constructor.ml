(* TEST
   {
     flags = "-optopen";
     native;
     bytecode;
   }
   {
     native;
     bytecode;
   }
*)

type t = ..

let count = ref 0

let make f =
  let module M = 
    struct
      type t += A
    end
  in
  incr count;
  let c = !count in
  (fun () -> M.A),
  (function M.A -> Printf.printf "A(%d)\n" c | e -> f e)


let _ =
  let (m1, s1) = make (function _ -> print_endline "unknown") in
  let (m2, s2) = make s1 in
  let (m3, s3) = make s2 in

  s1 (m1 ());
  s1 (m2 ());
  s1 (m3 ());

  s2 (m1 ());
  s2 (m2 ());
  s2 (m3 ());

  s3 (m1 ());
  s3 (m2 ());
  s3 (m3 ())
