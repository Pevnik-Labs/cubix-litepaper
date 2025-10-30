from DonutShop import
  DonutShopOwnershipToken
  collectProfits
  getMyShopRef

ownershipTokenAddr
: Address
= 0x22bf7f5182a7d22decc11f2a8fd94e2c6834cebd2ab2b239cab598987454bc1b

main
: Ledger -> Ledger
| ledger =>
  let (myAddress, ledger) = whoami ledger in
  let (optOwnershipToken, ledger) =
    delete DonutShopOwnershipToken ownershipTokenAddr ledger in
  match optOwnershipToken with
  | some ownershipToken =>
    let (shopRef, ownershipToken) = getMyShopRef ownershipToken in
    let (shop, returnShop) = update shopRef ledger in
    let (profitsCoin, shop) = collectProfits ownershipToken shop in
    let ledger = returnShop shop in
    let (newCoinAddr, initCoinCell) = new myAddress ledger in
    let ledger = initCoinCell profitsCoin in
    let (newTokenAddr, initTokenCell) = new myAddress ledger in
    let ledger = initTokenCell ownershipToken in
    ledger
  | none => ledger

