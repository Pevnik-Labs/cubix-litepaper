// Donut - simple purchasable object
record type Donut : Type1 where
  serialNumber : Nat

// Donut shop - shared object
record type DonutShop : Type1 where
  owner : Address
  price : Nat
  balance : KhalaniCoin
  nextSerialNumber : Nat

// Create a donut shop
init (ledger : Ledger) : Address * Ledger =
  let (sender, ledger) = whoami ledger in
  let shop : DonutShop = record where
    owner = sender
    price = 1000
    balance = coinZero
    nextSerialNumber = 0 in
  share shop ledger

// One can buy a donut for a set price
buyDonut (payment : KhalaniCoin) (shop : DonutShop) :
    Option Donut * KhalaniCoin * DonutShop =
  let (splitResult, change) = coinSplit shop.price payment in
  match splitResult with
  | none => (none, change, shop)
  | some paid =>
    let newBalance = coinMerge shop.balance paid in
    let newSerialNumber = shop.nextSerialNumber in
    let newShop : DonutShop =
      record shop where
        balance = newBalance
        nextSerialNumber = newSerialNumber + 1 in
    let donut : Donut = record where serialNumber = newSerialNumber in
    (some donut, change, newShop)

// Consume donut and get nothing useful in return
eatDonut (donut : Donut) : Unit =
  let record {} = donut in ()

// Collects profits from shop (succeeds only for owner)
collectProfits (shop : DonutShop) (ledger : Ledger) :
    KhalaniCoin * DonutShop * Ledger =
  let (sender, ledger) = whoami ledger in
  if shop.owner == sender then
    let profits = shop.balance in
    let newShop = record shop with balance = coinZero in
    (profits, newShop, ledger)
  else
    (coinZero, shop, ledger)
