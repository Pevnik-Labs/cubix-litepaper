data List (A : Type) : Type where
  nil
  cons (h : A) (t : List A)

app @(A : Type) (l1 l2 : List A) : List A =
  match l1 with
  | nil      => l2
  | cons h t => cons h (app t l2)

map @A @B (f : A -> B) : List A -> List B
| nil      => nil
| cons h t => cons (f h) (map f t)
