trait Coin (A : Type1) where
  coinAmount : A -> Nat * A
  coinZero   : A
  coinMerge  : A -> A -> A
  coinSplit  : Nat -> A -> Option A * A

record ExampleCoin : Type1 where
  amount : Nat

instance Coin ExampleCoin where
  coinZero : ExampleCoin =
    record where amount = 0

  coinMerge (c1 c2 : ExampleCoin) : ExampleCoin =
    record where amount = c1.amount + c2.amount

  coinAmount (c : ExampleCoin) : Nat * ExampleCoin =
    let n : Nat = c.amount in
      (n, record where amount = n)

  coinSplit (askedAmount : Nat) (c : ExampleCoin) :
    Option ExampleCoin * ExampleCoin =
      let n : Nat = c.amount in
        if askedAmount <= n
        then
          ( some (record where amount = askedAmount)
          , record where amount = n - askedAmount
          )
        else
          (none, record where amount = n)
