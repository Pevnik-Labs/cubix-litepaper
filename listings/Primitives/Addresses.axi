Account : Type1

Address : Type

Ref : Type1 -> Type

addressof : forall (A : Type1), Ref A -> Address

referenceof : forall @(A : Type1),
  Address -> Ledger -> Option (Ref A) * Ledger
