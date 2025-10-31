from DonutShop import
  DonutShopOwnershipToken
  collectProfits

ownershipTokenAddr : Address =
  0x22bf7f5182a7d22decc11f2a8fd94e2c6834cebd2ab2b239cab598987454bc1b

main (ledger : Ledger) : Ledger =
  let
    (myAddress, ledger) = whoami ledger in
    (optOwnershipToken, ledger) =
      delete DonutShopOwnershipToken ownershipTokenAddr ledger
  in
  match optOwnershipToken with
  | none => ledger
  | some ownershipToken =>
    let
      shopRef = ownershipToken.myShopRef
      (shop, returnShop) = update shopRef ledger
      (profits, shop) = collectProfits ownershipToken shop
      ledger = returnShop shop
      (newCoinAddr, initCoinCell) = new ExampleCoin myAddress ledger
      ledger = initCoinCell profits
      (newTokenAddr, initTokenCell) =
        new DonutShopOwnershipToken myAddress ledger
    in
      initTokenCell ownershipToken
