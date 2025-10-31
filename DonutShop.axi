module DonutShop where

// Exporting the types would allow public access
// to constructors and record updates which we don't want.
// Since the types are mentioned in the signatures
// they will be public but opaque.
export
  init
  buyDonut
  collectProfits
  getMyShopRef

// Donut - a simple purchasable object. It can be used at most once.
record Donut : Type? where
  serialNumber : Nat

// Donut shop - it knows its address, donut price,
// the amount of money it earned so far, and the
// serial number of the next donut to be sold.
record DonutShop : Type1 where
  thisShop : Address
  balance : ExampleCoin
  price : Nat
  nextSerialNumber : Nat

// A token which allows the owner to collect profits from his shop.
record DonutShopOwnershipToken : Type1 where
  myShopRef : Ref DonutShop

// Create a new donut shop, with donut price set to `myPrice`.
init (myPrice : Nat) (ledger : Ledger)
  : DonutShopOwnershipToken * Ledger =
  let
    (shopRef, publishShopToLedger) = share DonutShop ledger
    ownership : DonutShopOwnershipToken =
      record where myShopRef = shopRef
    newShop : DonutShop = record where
      thisShop = addressOf shopRef
      price = myPrice
      balance = coinZero
      nextSerialNumber = 0
  in
    (ownership, publishShopToLedger newShop)

// Buy a donut from the shop. The outputs are: the donut
// (if successfully bought), the change and the updated shop.
buyDonut (payment : ExampleCoin) (shop : DonutShop)
  : Option Donut * ExampleCoin * DonutShop =
  let (splitResult, change) = coinSplit shop.price payment in
  match splitResult with
  | none => (none, change, shop)
  | some paid =>
    let
      num : Nat = shop.nextSerialNumber
      donut : Donut = record where serialNumber = num
      newBalance = coinMerge shop.balance paid
      newShop : DonutShop = record shop where
        balance = newBalance
        nextSerialNumber = num + 1
    in
      (some donut, change, newShop)

// Collect profits from the shop (succeeds only for the owner).
collectProfits (ownership : DonutShopOwnershipToken) (shop : DonutShop)
  : ExampleCoin * DonutShop * DonutShopOwnershipToken =
  let shopRef = ownership.myShopRef in
  if addressOf shopRef == shop.thisShop
  then
    let
      profits = shop.balance
      newShop = record shop where balance = coinZero
    in
      (profits, newShop, ownership)
  else
    (coinZero, shop, ownership)
