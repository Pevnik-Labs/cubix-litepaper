data type List (A : Type) : Type where
  nil : List A
  cons : A -> List A -> List A

map @(A B : Type) (f : A -> B)
: List A -> List B
| nil => nil
| cons x xs => cons (f x) (map f xs)

mapRevApp @(A B : Type) (f : A -> B)
: List A -> List B -> List B
| nil, ys => ys
| cons x xs, ys => mapRevApp f xs (cons (f x) ys)

revApp @(A : Type)
: List A -> List A -> List A
| nil, ys => ys
| cons x xs, ys => revApp xs (cons x ys)

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
