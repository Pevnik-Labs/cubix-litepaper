interface Coin (A : Type1) where
  coinAmount : A -> Nat * A
  coinZero : A
  coinMerge : A -> A -> A
  coinSplit : CoinAmount -> A -> Option A * A
  theorem coinZero-spec :
    let x = coinZero in
    let (a, _) = coinAmount x in
    a === 0
  theorem coinMerge-spec :
    forall @(x : A) @(y : A),
    let (a, _) = coinAmount x in
    let (b, _) = coinAmount y in
    let z = coinMerge x y in
    let (c, _) = coinAmount z in
    c === a + b
  theorem coinSplit-spec :
    forall @(n : Nat) @(coin : A),
    let (a, _) = coinAmount coin in
    match coinSplit n coin with
    | (none, whole) =>
      (n <= a) === false /\
      let (b, _) = coinAmount whole in
      b === a
    | (some exact, change) =>
      (n <= m) === true /\
      let (b, _) = coinAmount y in
      b === n /\
      let (c, _) = coinAmount z in
      c === a - n

record type KhalaniCoin : Type1 where
  amount : Nat

instance Coin KhalaniCoin where
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
  theorem coinZero-spec :
    let x = coinZero in
    let (a, _) = coinAmount x in
    a === 0
  proof
    refl
  qed
  // other proofs elided
