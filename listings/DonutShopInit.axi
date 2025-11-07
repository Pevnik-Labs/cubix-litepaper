from DonutShop import
  init

main
: Ledger -> Ledger
| ledger =>
  let
    (myAccountRef, ledger) = transactor ledger
    price = 1000
    (ownershipToken, ledger) = init price ledger
    (tokenAddress, initOwnershipTokenCell) = new myAccountRef ledger
    ledger = initOwnershipTokenCell ownershipToken
  in
  ledger
