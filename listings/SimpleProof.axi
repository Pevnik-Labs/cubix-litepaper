theorem app-assoc :
  forall (A : Type) @(l1 l2 l3 : List A),
    app (app l1 l2) l3 === app l1 (app l2 l3)
proof
  pick-any A l1
  induction l1 with
  | nil =>
    pick-any l2 l3
    refl
  | cons h (t & ind IH) =>
    pick-any l2 l3
    chaining
      === app (app (cons h t) l2) l3
      === cons h (app (app t l2) l3)
      === cons h (app t (app l2 l3))  by rewrite IH
      === app (cons h t) (app l2 l3)
qed
