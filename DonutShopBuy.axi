from DonutShop import
  Donut
  DonutShop
  buyDonut

coinAddr : Address =
  0x0664eebd187e0668e41e5d2236eaafe2d54dd9dbc76685e4ceac69c908c26446

shopAddr : Address =
  0xf09785359712726892a2ec3b8b7cf460f0f6dd82e0bf5a7a8d2f2276035888cf

main (ledger : Ledger) : Ledger =
  let
    (myAddress, ledger) = whoami ledger
    (optShopRef, ledger) = referenceOf DonutShop shopAddr ledger
  in
  match optShopRef with
  | none => ledger
  | some shopRef =>
    let (optCoin, ledger) = delete ExampleCoin coinAddr ledger in
    match optCoin with
    | none => ledger
    | some paymentCoin =>
      let
        (shop, returnShop) = update shopRef ledger
        (optDonut, changeCoin, shop) = buyDonut paymentCoin shop
        ledger = returnShop shop
        (newCoinAddr, initCoinCell) = new ExampleCoin myAddress ledger
        ledger = initCoinCell changeCoin
      in
      match optDonut with
      | none => ledger
      | some donut =>
        let (donutAddr, initDonutCell) = new Donut myAddress ledger in
          initDonutCell donut
