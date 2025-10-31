module DonutShop where

// Exporting the types would allow public access
// to constructors and record updates which we don't want.
// Since the types are mentioned in the signatures
// they will be public but opaque.
export
  init
  buyDonut
  getMyShopRef
  collectProfits

// Donut - a simple purchasable object. It can be used at most once.
record Donut : Type? where
  serialNumber : Nat

// Donut shop - it knows its address, donut price,
// the amount of money it earned so far, and the
// serial number of the next donut to be sold.
record DonutShop : Type1 where
  thisShop : Address
  price : Nat
  balance : KhalaniCoin
  nextSerialNumber : Nat

// A token which allows the owner to collect profits from his shop.
record DonutShopOwnershipToken : Type1 where
  myShopRef : Ref DonutShop

// Create a new donut shop, with donut price set to `myPrice`.
init (myPrice : Nat) (ledger : Ledger)
: DonutShopOwnershipToken * Ledger
= let
    (shopRef, publishShopToLedger) = share ledger
    ownership : DonutShopOwnershipToken =
      record where myShopRef = shopRef
    shop : DonutShop = record where
      thisShop = addressof shopRef
      price = myPrice
      balance = coinZero
      nextSerialNumber = 0
  in
  (ownership, publishShopToLedger shop)

// Buy a donut from the shop. The outputs are: the donut
// (if successfully bought), the change and the updated shop.
buyDonut (payment : KhalaniCoin) (shop : DonutShop)
: Option Donut * KhalaniCoin * DonutShop
= let (splitResult, change) = coinSplit shop.price payment in
  match splitResult with
  | none => (none, change, shop)
  | some paid =>
    let
      donutSerialNumber = shop.nextSerialNumber
      donut : Donut = record where serialNumber = donutSerialNumber
      newBalance = coinMerge shop.balance paid
      newShop : DonutShop =
        record shop where
          balance = newBalance
          nextSerialNumber = donutSerialNumber + 1
    in
    (some donut, change, newShop)

// Read shop reference from an ownership token
getMyShopRef (ownership : DonutShopOwnershipToken)
: DonutShop * DonutShopOwnershipToken
= (token.myShopRef, token)

// Collect profits from the shop (succeeds only for the owner).
collectProfits (ownership : DonutShopOwnershipToken) (shop : DonutShop)
: KhalaniCoin * DonutShopOwnershipToken * DonutShop
= if addressof ownership.myShop == shop.thisShop then
    let
      profits = shop.balance
      shop = record shop where balance = coinZero
    in
    (profits, ownership, shop)
  else
    (coinZero, ownership, shop)
