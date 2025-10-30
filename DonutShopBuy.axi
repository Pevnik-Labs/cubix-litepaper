from DonutShop import
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
  let (myAddress, ledger) = whoami ledger in
  let (optShopRef, ledger) = referenceof DonutShop shopAddr ledger in
  match optShopRef with
  | some shopRef =>
    let (optCoin, ledger) = delete KhalaniCoin coinAddr ledger in
    match optCoin with
    | some paymentCoin =>
      let (shop, returnShop) = update shopRef ledger in
      let (optDonut, changeCoin, shop) = buyDonut paymentCoin shop in
      let ledger = returnShop shop in
      let (newCoinAddr, initCoinCell) = new myAddress ledger in
      let ledger = initCoinCell changeCoin in
      match optDonut with
      | some donut =>
        let (newDonutAddr, initDonutCell) = new myAddress ledger in
        let ledger = initDonutCell donut in
        ledger
      | none => ledger
    | none => ledger
  | none => ledger

