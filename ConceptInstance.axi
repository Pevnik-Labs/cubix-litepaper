instance LawfulCoin ExampleCoin where
  theorem coinAmount-spec :
    forall @(x : ExampleCoin),
      let (_, y) = coinAmount x in x === y
  proof
    pick-any x
    refl
  qed

  theorem coinZero-spec :
    coinAmount coinZero === (0, coinZero)
  proof
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

  // The proofs of coinSplit-none and coinSplit-some were elided.
