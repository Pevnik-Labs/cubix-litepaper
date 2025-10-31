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
  let
    (myAddress, ledger) = whoami ledger
    (optOwnershipToken, ledger) =
      delete DonutShopOwnershipToken ownershipTokenAddr ledger
  in
  match optOwnershipToken with
  | none => ledger
  | some ownershipToken =>
    let
      (shopRef, ownershipToken) = getMyShopRef ownershipToken
      (shop, returnShop) = update shopRef ledger
      (profits, ownershipToken, shop) = collectProfits ownershipToken shop
      ledger = returnShop shop
      (newCoinAddr, initCoinCell) = new myAddress ledger
      ledger = initCoinCell profits
      (newTokenAddr, initTokenCell) = new myAddress ledger
      ledger = initTokenCell ownershipToken
    in
    ledger

