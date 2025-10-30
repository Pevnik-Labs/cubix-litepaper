trait Coin (A : Type1) where
  coinAmount : A -> Nat * A
  coinZero   : A
  coinMerge  : A -> A -> A
  coinSplit  : Nat -> A -> Option A * A

record ExampleCoin : Type1 where
  amount : Nat

instance Coin ExampleCoin where
  coinAmount (c : ExampleCoin) : Nat * ExampleCoin =
    (c.amount, c)

  coinZero = record where amount = 0

  coinMerge (c1 c2 : ExampleCoin) : ExampleCoin =
    record where amount = c1.amount + c2.amount

  coinSplit (amount : Nat) (c : ExampleCoin) :
      Option ExampleCoin * ExampleCoin =
    if amount <= c.amount
    then
      ( some (record where amount = amount)
      , record where amount = c.amount - amount
      )
    else
      (none, c)
