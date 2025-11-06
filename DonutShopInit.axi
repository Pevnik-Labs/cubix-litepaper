from DonutShop import
  init

main
: Ledger -> Ledger
| ledger =>
  let
    (myAddress, ledger) = whoami ledger
    price = 1000
    (ownershipToken, ledger) = init price ledger
  in
  match new myAddress ledger with
  | Left ledger => ledger
  | Right (tokenAddress, initTokenCell) =>
    let
      ledger = initTokenCell ownershipToken
    in
    ledger

