concept LawfulCoin (A : Type1) extends Coin A where
  coinAmount' (x : A) : Nat =
    let (n, _) = coinAmount c in n

  theorem coinZero-spec :
    coinAmount coinZero === (0, coinZero)

  theorem coinAmount-spec :
    forall @(x : A),
      let (_, y) = coinAmount x in x === y

  theorem coinMerge-spec :
    forall @(x y : A),
      coinAmount' (coinMerge x y)
        ===
      coinAmount' x + coinAmount' y

  theorem coinSplit-spec :
    forall @(n : Nat) @(coin : A),
      match coinSplit n coin with
      | (none, whole) =>
          (n <= a) === false /\ whole === coin
      | (some exact, change) =>
          (n <= m) === true
            /\
          coinAmount' exact === n
            /\
          coinAmount' change === coinAmount' coin - n

instance LawfulCoin ExampleCoin where
  theorem coinZero-spec :
    coinAmount coinZero === (0, coinZero)
  proof
    refl
  qed

  theorem coinAmount-spec :
    forall @(x : ExampleCoin),
      let (_, y) = coinAmount x in x === y
  proof
    pick-any x
    refl
  qed

  theorem coinMerge-spec :
    forall @(x y : ExampleCoin),
      coinAmount' (coinMerge x y)
        ===
      coinAmount' x + coinAmount' y
  proof
    pick-any x y
    refl
  qed

  // The proof of coinSplit-spec was elided, because it's harder :)