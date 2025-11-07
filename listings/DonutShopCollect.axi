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
    (myAccountRef, ledger) = transactor ledger
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
      (newCoinAddr, initCoinCell) = new myAccountRef ledger
      ledger = initCoinCell profits
      (newTokenAddr, initOwnershipTokenCell) = new myAccountRef ledger
      ledger = initOwnershipTokenCell ownershipToken
    in
    ledger
