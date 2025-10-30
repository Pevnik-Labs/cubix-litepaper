concept LawfulCoin (A : Type1) extends Coin A where
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

instance LawfulCoin ExampleCoin where
  theorem coinZero-spec :
    let x = coinZero in
    let (a, _) = coinAmount x in
    a === 0
  proof
    refl
  qed
  // Other proofs elided.
