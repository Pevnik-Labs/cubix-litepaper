from DonutShop import
  init

main (ledger : Ledger) : Ledger =
: Ledger -> Ledger
| ledger =>
  let (myAddress, ledger) = whoami ledger in
  let (ownershipToken, ledger) = init ledger in
  let (tokenAddress, initTokenCell) = freeze myAddress ledger in
  let ledger = initTokenCell ownershipToken in
  ledger

