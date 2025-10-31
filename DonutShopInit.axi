from DonutShop import
  init

main
: Ledger -> Ledger
| ledger =>
  let
    (myAddress, ledger) = whoami ledger
    price = 1000
    (ownershipToken, ledger) = init price ledger
    (tokenAddress, initTokenCell) = new myAddress ledger
    ledger = initTokenCell ownershipToken
  in
  ledger

