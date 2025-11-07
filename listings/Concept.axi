concept LawfulCoin (A : Type1) extends Coin A where
  noncomputable coinAmount' (x : A) : Nat =
    let (n, _) = coinAmount c in n

  law coinAmount-spec :
    forall @(x : A),
      let (_, y) = coinAmount x in x === y

  law coinZero-spec :
    coinAmount' coinZero === 0

  law coinMerge-spec :
    forall @(x y : A),
      coinAmount' (coinMerge x y)
        ===
      coinAmount' x + coinAmount' y

  law coinSplit-none :
    forall @(askedAmount : Nat) @(coin coin' : A),
      coinSplit askedAmount coin === (none, coin')
        <-->
      (askedAmount <= coinAmount' coin) === false
        /\
      coin === coin'

  law coinSplit-some :
    forall @(askedAmount : Nat) @(coin exact change : A),
      coinSplit askedAmount coin === (some exact, change)
        <-->
      (askedAmount <= coinAmount' coin) === true
        /\
      coinAmount' exact === askedAmount
        /\
      coinAmount' change === coinAmount' coin - askedAmount
