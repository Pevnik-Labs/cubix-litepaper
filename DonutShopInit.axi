from DonutShop import
  DonutShopOwnershipToken
  init

main (ledger : Ledger) : Ledger =
  let
    (myAddress, ledger) = whoami ledger
    (ownershipToken, ledger) = init 1000 ledger
    (tokenAddress, initTokenCell) =
      new DonutShopOwnershipToken myAddress ledger
  in
    initTokenCell ownershipToken
