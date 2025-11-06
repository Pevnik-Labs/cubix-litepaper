from DonutShop import
  DonutShopOwnershipToken
  init

main
: Ledger -> Ledger
| ledger =>
  let
    (myAddress, ledger) = whoami ledger
    price = 1000
    (ownershipToken, ledger) = init price ledger
  in
  match new @DonutShopOwnershipToken myAddress ledger with
  | left ledger => ledger
  | right (tokenAddress, initTokenCell) =>
    let
      ledger = initTokenCell ownershipToken
    in
    ledger

