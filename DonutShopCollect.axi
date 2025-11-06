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
    in
    match new @KhalaniCoin myAddress ledger with
    | left ledger => ledger
    | right (newCoinAddr, initCoinCell) =>
      let
        ledger = initCoinCell profits
      in
        match new @DonutShopOwnershipToken myAddress ledger with
        | left ledger => ledger
        | right (newTokenAddr, initTokenCell) =>
          let
            ledger = initTokenCell ownershipToken
          in
          ledger

