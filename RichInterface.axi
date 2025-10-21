interface Coin (A : Type1) where
  CoinAmount : Type
  coinAmount : A -> CoinAmount * A
  coinZero : A
  coinMerge : A -> A -> A
  coinSplit : CoinAmount -> A -> Option A * A

record type KhalaniCoin : Type1 where
  amount : Nat

instance Coin KhalaniCoin where
  CoinAmount = Nat
  coinAmount (coin : KhalaniCoin) : Nat * KhalaniCoin =
    (coin.amount, coin)
  coinZero = record where amount = 0
  coinMerge (coin1 coin2 : KhalaniCoin) : KhalaniCoin =
    record where amount = coin1.amount + coin2.amount
  coinSplit (amount : Nat) (coin : KhalaniCoin) :
      Option KhalaniCoin * KhalaniCoin =
    if amount <= coin.amount then
      ( some (record where amount = amount)
      , record where amount = coin.amount - amount
      )
    else
      (none, coin)
