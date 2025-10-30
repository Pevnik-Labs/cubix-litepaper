noncomputational coinAmount' @A [Coin A] (x : A) : Nat =
  let (n, _) : Nat * A = coinAmount c in n

concept LawfulCoin (A : Type1) extends Coin A where
  theorem coinZero-spec :
    coinAmount coinZero === (0, coinZero)

  theorem coinMerge-spec :
    forall @(x y : A),
      let
        (a, x) = coinAmount x
        (b, y) = coinAmount y
        z = coinMerge x y
        (c, _) = coinAmount z
      in
        c === a + b

  theorem coinSplit-spec :
    forall @(n : Nat) @(coin : A),
      let (a, coin) = coinAmount coin in
        match coinSplit n coin with
        | (none, whole) =>
          (n <= a) === false
            /\
          let (b, _) = coinAmount whole in b === a
        | (some exact, change) =>
          (n <= m) === true
            /\
          let (b, _) = coinAmount exact in b === n
            /\
          let (c, _) = coinAmount change in c === a - n

instance LawfulCoin ExampleCoin where
  theorem coinZero-spec :
    coinAmount coinZero === (0, coinZero)
  proof
    refl
  qed
  // Other proofs elided.
