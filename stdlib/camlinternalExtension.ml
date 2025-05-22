external field : extension_constructor -> int -> 'a = "%obj_field"

external ( < ) : int -> int -> bool = "%lessthan"
external ( > ) : int -> int -> bool = "%greaterthan"
external ( = ) : int -> int -> bool = "%equal"

type table =
  | Node of int * int * table * table
  | Leaf

let rec table_insert ((id, value) as va) table =
  match table with
    | Leaf ->
        Node (id, value, Leaf, Leaf)

    | Node (nid, nvalue, left, right) ->
        if id < nid then
          Node (nid, nvalue, table_insert va left, right)
        else if id > nid then
          Node (nid, nvalue, left, table_insert va right)
        else
          (* This should happen when matching over rebinded type, so discard previous value*)
          Node (nid, value, left, right)

let rec table_find id table =
  match table with
    | Leaf ->
        0

    | Node (nid, nvalue, left, right) ->
        if nid = id then
          nvalue
        else if id < nid then
          table_find id left
        else
          table_find id right


let rec init_table env table =
  match env with
    | (constr, value) :: tl ->
        let id = field constr 1 in
        init_table tl (table_insert (id, value) table)

    | [] ->
        table


let init_match env =
  let table = init_table env Leaf in

  fun id ->
    table_find id table
