(* TEST
   flags = "-optopen";
   native;
   bytecode;
*)


(**
   Test that value match failure in a match block raises Match_failure.
*)

let test_partial_match f =
  try
    let _ = (match f () with
      | Some x when x < 10 ->
          Printf.printf "Some %d\n" x
      | exception Failure e ->
          print_endline ("Failure " ^ e)
      | Some x when x < 20 ->
          Printf.printf "Some %d\n" x
      | exception Invalid_argument e ->
          print_endline ("Invalid_argument " ^ e)
    ) [@ocaml.warning "-8"] in
    ()
  with
    Match_failure _ ->
      print_endline "match failure, as expected"
;;

let _ =
  test_partial_match (fun () -> Some 3);
  test_partial_match (fun () -> Some 15);
  test_partial_match (fun () -> raise (Failure "I just failed"));
  test_partial_match (fun () -> raise (Invalid_argument "arg"));
  test_partial_match (fun () -> Some 245)
;;


(**
   Test that we can match over exceptions and try/catch
*)
let _ =
  try
    (match (raise Not_found) with
      | exception Not_found ->
          raise (Failure "yes")
      | _ ->
          raise (Failure "no"))
  with
    | Not_found ->
        print_endline "Not_found"
    | Failure f ->
        print_endline ("Failure " ^ f)
    | exn ->
        raise exn
