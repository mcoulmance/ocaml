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

exception My_global_exn

let count = ref 0


let make f =
  let module M = 
    struct
      exception My_local_exn of int
    end
  in
  incr count;
  let c = !count in
  (fun () -> raise (M.My_local_exn c)),
  (fun v ->
    try
      v ()
    with
      | M.My_local_exn c -> 
          Printf.printf "My_local_exn(%d)\n" c
      | My_global_exn ->
          print_endline "My_global_exn"
      | _ ->
          f v)

let _ =
  let (r1, s1) = make (fun x -> try x () with _ -> print_endline "unknown") in
  let (r2, s2) = make s1 in
  let (r3, s3) = make s2 in

  s1 r1;
  s1 r2;
  s1 r3;

  s2 r1;
  s2 r2;
  s2 r3;

  s3 r1;
  s3 r2;
  s3 r3
