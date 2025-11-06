from DonutShop import
  Donut
  DonutShop
  buyDonut

coinAddr
: Address
= 0x0664eebd187e0668e41e5d2236eaafe2d54dd9dbc76685e4ceac69c908c26446

shopAddr
: Address
= 0xf09785359712726892a2ec3b8b7cf460f0f6dd82e0bf5a7a8d2f2276035888cf

main
: Ledger -> Ledger
| ledger =>
  let
    (myAddress, ledger) = whoami ledger
    (optShopRef, ledger) = referenceof DonutShop shopAddr ledger
  in
  match optShopRef with
  | none => ledger
  | some shopRef =>
    let (optCoin, ledger) = delete KhalaniCoin coinAddr ledger in
    match optCoin with
    | none => ledger
    | some paymentCoin =>
      let
        (shop, returnShop) = update shopRef ledger
        (optDonut, changeCoin, shop) = buyDonut paymentCoin shop
        ledger = returnShop shop
      in
      match new @KhalaniCoin myAddress ledger with
      | left ledger => ledger
      | right (newCoinAddr, initCoinCell) =>
        let
          ledger = initCoinCell changeCoin
        in
        match optDonut with
        | none => ledger
        | some donut =>
          match new @Donut myAddress ledger with
          | left ledger => ledger
          | right (newDonutAddr, initDonutCell) =>
            let
              ledger = initDonutCell donut
            in
            ledger
