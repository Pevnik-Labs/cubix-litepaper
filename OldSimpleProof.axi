theorem revApp-map @(A : Type) @(B : Type) (f : A -> B) (xs : List A) :
  forall @(ys : List A), revApp (map f xs) ys === mapRevApp f xs ys
proof
  induction xs with
  | nil =>
    assume ys
    chaining
      === revApp (map f nil) ys
      === revApp nil ys
      === ys
      === mapRevApp f nil ys
  | cons x (xs & ind xsIH) =>
    assume ys
    chaining
      === revApp (map f (cons x xs)) ys
      === revApp (cons (f x) (map f xs)) ys
      === revApp (map f xs) (cons (f x) ys)
      === mapRevApp f xs (cons (f x) ys)    by xsIH (cons (f x) ys)
      === mapRevApp f (cons x xs) ys
qed
