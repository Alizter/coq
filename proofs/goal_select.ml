(************************************************************************)
(*         *   The Coq Proof Assistant / The Coq Development Team       *)
(*  v      *         Copyright INRIA, CNRS and contributors             *)
(* <O___,, * (see version control and CREDITS file for authors & dates) *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

open Names

(* spiwack: I'm choosing, for now, to have [goal_selector] be a
   different type than [goal_reference] mostly because if it makes sense
   to print a goal that is out of focus (or already solved) it doesn't
   make sense to apply a tactic to it. Hence it the types may look very
   similar, they do not seem to mean the same thing. *)


type atomic_t =
  | SelectNth of int
  | SelectRange of int * int
  | SelectId of Id.t

type t =
  | SelectList of atomic_t list
  | SelectAlreadyFocused
  | SelectAll

let pr_atomic_goal_selector = function
  | SelectNth i -> Pp.int i
  | SelectRange (i, j) -> if i = j then Pp.int i else Pp.(int i ++ str "-" ++ int j)
  | SelectId id -> Pp.(str "[" ++ Names.Id.print id ++ str "]")

let pr_goal_selector = function
  | SelectAlreadyFocused -> Pp.str "!"
  | SelectList l -> Pp.(prlist_with_sep pr_comma pr_atomic_goal_selector l)
  | SelectAll -> Pp.str "all"

let parse_goal_selector = function
  | "!" -> SelectAlreadyFocused
  | "all" -> SelectAll
  | i ->
      let err_msg = "The default selector must be \"all\", \"!\" or a natural number." in
      begin try
              let i = int_of_string i in
              if i < 0 then CErrors.user_err Pp.(str err_msg);
              SelectList [SelectNth i]
        with Failure _ -> CErrors.user_err Pp.(str err_msg)
      end

(* Default goal selector: selector chosen when a tactic is applied
   without an explicit selector. *)
let get_default_goal_selector =
  Goptions.declare_interpreted_string_option_and_ref
    ~depr:false
    ~key:["Default";"Goal";"Selector"]
    ~value:(SelectList [SelectNth 1])
    parse_goal_selector
    (fun v -> Pp.string_of_ppcmds @@ pr_goal_selector v)

(** TODO: move to clib *)
(* Take a list of intervals and merge overlaps *)
let merge_intervals is =
  let rec merge_intervals_helper merged xs =
    match merged , xs with
    | merged , [] -> CList.rev merged
    | [] , x :: xs -> merge_intervals_helper [x] xs
    | (a,b) :: merged , (c,d) :: xs ->
      if b >= c then
        merge_intervals_helper ((a, max b d) :: merged) xs
      else
        merge_intervals_helper ((c, d) :: (a, b) :: merged) xs
  in
  merge_intervals_helper [] (CList.sort (fun a b -> Int.compare (fst a) (fst b)) is)

(* Normalize a range: Takes a list of goal selectors and flattens it into a
   well-formed partition of the goals together with a list . *)
let normalize gs =
  (* We accumate the ranges and shelved identifiers. *)
  let rec normalize_accum rs ids gs =
    match gs with
    | [] -> rs, ids
    | SelectNth i :: hs ->
      normalize_accum (merge_intervals ((i, i) :: rs)) ids hs
    | SelectRange (i, j) :: hs ->
      normalize_accum (merge_intervals ((i, j) :: rs)) ids hs
    | SelectId id :: hs ->
      (* First resolve name: is it numbered goal or not?
        If it is numbered goal then add number accodingly
        If it is not numbered goal then add to ids
       *)
      rs, ids
  in
  normalize_accum [] [] gs

let tclSELECTATOM ?nosuchgoal g tac = function
  | SelectNth i -> Proofview.tclFOCUS ?nosuchgoal i i tac
  | SelectRange (i, j) -> Proofview.tclFOCUS ?nosuchgoal i j tac
  | SelectId id -> Proofview.tclFOCUSID ?nosuchgoal id tac

(* Select a subset of the goals *)
let tclSELECT ?nosuchgoal g tac = match g with
  | SelectAll -> tac
  | SelectList l ->
    let open Proofview.Notations in
    let l,ids = normalize l in
    (* CList.map (fun x -> tclSELECTATOM ?nosuchgoal (SelectRange x) tac) (merge_intervals l) *)
    Proofview.tclTHEN
      (Proofview.tclFOCUSLIST ?nosuchgoal l tac)
      (CList.fold_left (fun tac id -> Proofview.tclFOCUSID ?nosuchgoal id tac) tac ids)

  | SelectAlreadyFocused ->
    let open Proofview.Notations in
    Proofview.numgoals >>= fun n ->
    if n == 1 then tac
    else
      let e = CErrors.UserError
          Pp.(str "Expected a single focused goal but " ++
              int n ++ str " goals are focused.")
      in
      let info = Exninfo.reify () in
      Proofview.tclZERO ~info e
