data type List (A : Type) : Type where
  nil : List A
  cons : A -> List A -> List A

map @(A B : Type) (f : A -> B)
: List A -> List B
| nil => nil
| cons x xs => cons (f x) (map f xs)

app @A (l1 l2 : List A) : List A =
  match l1 with
  | nil      => l2
  | cons h t => cons h (app t l2)