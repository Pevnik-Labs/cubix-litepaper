module DonutShop where

// exporting the types would allow public access
// to constructors and record updates
// since the types are mentioned in the signatures
// the types will be public but opaque
export
  myShop
  init
  buyDonut
  collectProfits

// Donut - simple purchasable object, can be used at most once
record type Donut : Type? where
  serialNumber : Nat

// Donut shop - shared object
record type DonutShop : Type1 where
  thisShop : Address
  price : Nat
  balance : KhalaniCoin
  nextSerialNumber : Nat

record type DonutShopOwnershipToken : Type where
  myShop : Ref DonutShop

// Create a donut shop
init (ledger : Ledger)
: DonutShopOwnershipToken * Ledger
= let (shopRef, shopToLedger) = share ledger in
  let ownership : DonutShopOwnershipToken =
    record where
      myShop = shopRef in
  let shop : DonutShop = record where
    thisShop = shopRef
    price = 1000
    balance = coinZero
    nextSerialNumber = 0 in
  (ownership, shopRef, shopToLedger shop)

// One can buy a donut for a set price
buyDonut (payment : KhalaniCoin) (shop : DonutShop)
: Option Donut * KhalaniCoin * DonutShop
= let (splitResult, change) = coinSplit shop.price payment in
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

// Collects profits from shop (succeeds only for owner)
collectProfits (ownership : DonutShopOwnershipToken) (shop : DonutShop)
: KhalaniCoin * DonutShop
= if addressof ownership.myShop == shop.thisShop then
    let profits = shop.balance in
    let newShop = record shop with balance = coinZero in
    (profits, newShop, ledger)
  else
    (coinZero, shop, ledger)
