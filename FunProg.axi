data type List (A : Type) : Type where
  nil : List A
  cons : A -> List A -> List A

map @(A : Type) @(B : Type) (f : A -> B)
: List A -> List B
| nil => nil
| cons x xs => cons x (map f xs)

mapRevApp @(A : Type) @(B : Type) (f : A -> B)
: List A -> List B -> List B
| nil, ys => ys
| cons x xs, ys => mapRevApp f xs (cons (f x) ys)

revApp @(A : Type)
: List A -> List A -> List A
| nil, ys => ys
| cons x xs, ys => revApp xs (cons x ys)
