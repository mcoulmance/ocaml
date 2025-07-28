external field : extension_constructor -> int -> 'a = "%obj_field"

external ( < ) : int -> int -> bool = "%lessthan"
external ( > ) : int -> int -> bool = "%greaterthan"
external ( = ) : int -> int -> bool = "%equal"


type color = Red | Black

type table =
  | Node of color * int * int * table * table
  | Leaf

let no_match_found = 0

let balance = function
  | Black, z1, z2, Node (Red, y1, y2, Node (Red, x1, x2, a, b), c), d
  | Black, z1, z2, Node (Red, x1, x2, a, Node (Red, y1, y2, b, c)), d
  | Black, x1, x2, a, Node (Red, z1, z2, Node (Red, y1, y2, b, c), d)
  | Black, x1, x2, a, Node (Red, y1, y2, b, Node (Red, z1, z2, c, d)) ->
    Node (Red, y1, y2, Node (Black, x1, x2, a, b), Node (Black, z1, z2, c, d))
  | a, b, c, d, e -> Node (a, b, c, d, e)

let rec insert ((id, value) as va) table =
  match table with
    | Leaf ->
        Node (Red, id, value, Leaf, Leaf)
    | Node (color, nid, nvalue, left, right) as node ->
        if id < nid then
          balance (color, nid, nvalue, insert va left, right)
        else if id > nid then
          balance (color, nid, nvalue, left, insert va right)
        else
          (* This should happen when matching over rebinded constructors.
             Since constructors are added to the table in reverse order of
             appearance in the patterns list, we simply need to
             discard the to-be-inserted value to preserve the rebinding property
          *)
          node

let insert va table =
  match insert va table with
    | Node (_, a, b, c, d) ->
        Node (Black, a, b, c, d)
    | _ ->
        assert false

let rec find id table =
  match table with
    | Leaf ->
        no_match_found
    | Node (_, nid, nvalue, left, right) ->
        if nid = id then
          nvalue
        else if id < nid then
          find id left
        else
          find id right

let rec init env table =
  match env with
    | (constr, value) :: tl ->
        let id = field constr 1 in
        init tl (insert (id, value) table)
    | [] ->
        table

let init_match env =
  let table = init env Leaf in
  fun id -> find id table
