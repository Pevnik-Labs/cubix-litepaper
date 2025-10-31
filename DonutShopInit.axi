from DonutShop import
  init

main
: Ledger -> Ledger
| ledger =>
  let
    (myAddress, ledger) = whoami ledger
    (ownershipToken, ledger) = init ledger
    (tokenAddress, initTokenCell) = new myAddress ledger
    ledger = initTokenCell ownershipToken
  in
  ledger

