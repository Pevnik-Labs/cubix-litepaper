trait Coin (A : Type1) where
  coinAmount : A -> Nat * A
  coinZero   : A
  coinMerge  : A -> A -> A
  coinSplit  : Nat -> A -> Option A * A

record CubixCoin : Type1 where
  amount : Nat

instance Coin CubixCoin where
  coinZero : CubixCoin =
    record where amount = 0

  coinMerge (c1 c2 : CubixCoin) : CubixCoin =
    record where amount = c1.amount + c2.amount

  coinAmount (c : CubixCoin) : Nat * CubixCoin =
    let n : Nat = c.amount in
      (n, record where amount = n)

  coinSplit (askedAmount : Nat) (c : CubixCoin) :
    Option CubixCoin * CubixCoin =
      let n : Nat = c.amount in
        if askedAmount <= n then
          ( some (record where amount = askedAmount)
          , record where amount = n - askedAmount
          )
        else
          (none, record where amount = n)
