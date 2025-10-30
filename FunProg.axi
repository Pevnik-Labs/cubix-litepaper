data type List (A : Type) : Type where
  nil : List A
  cons : A -> List A -> List A

app : forall (A : Type), List A -> List A -> List A
| nil, ys => ys
| cons x xs, ys => cons x (app xs ys)
