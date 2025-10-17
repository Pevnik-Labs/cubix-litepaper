primitive
  Ledger : Type1
  Address : Type
  whoami : Ledger -> Address * Ledger
  transfer : forall (A : Type1), Address -> A -> Ledger -> Address * Ledger
  share : forall (A : Type1), A -> Ledger -> Address * Ledger
  halt : Ledger -> Ledger

interface Coin (A : Type1) where
  CoinAmount : Type
  coinAmount : A -> CoinAmount * A
  coinZero : A
  coinMerge : A -> A -> A
  coinSplit : CoinAmount -> A -> Option A * A

record type KhalaniCoin : Type1 where
  amount : Nat

instance Coin KhalaniCoin where
  CoinAmount = Nat
  coinAmount (coin : KhalaniCoin) : Nat * KhalaniCoin = (coin.amount, coin)
  coinZero = record where amount = 0
  coinMerge (coin1 coin2 : KhalaniCoin) : KhalaniCoin = 
    record where amount = coin1.amount + coin2.amount
  coinSplit (amount : Nat) (coin : KhalaniCoin) : Option KhalaniCoin * KhalaniCoin =
    if amount <= coin.amount then
      (some (record where amount = amount), record where amount = coin.amount - amount)
    else
      (none, coin)

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
init (ledger : Ledger) : Ledger =
  let (sender, ledger) = whoami ledger in
  let shop : DonutShop = record where
    owner = sender
    price = 1000
    balance = coinZero
    nextSerialNumber = 0 in
  let (_shopId, ledger) = share shop ledger in
  ledger

// Anybody can buy a donut for a set price
buyDonut (payment : KhalaniCoin) (shop : DonutShop) (ledger : Ledger) : KhalaniCoin * DonutShop * Ledger =
  let (splitResult, change) = coinSplit shop.price payment in
  match splitResult with
  | none => (change, shop, halt ledger)
  | some paid =>
    let newBalance = coinMerge shop.balance paid in
    let newSerialNumber = shop.nextSerialNumber in
    let newShop : DonutShop =
      record shop where
        balance = newBalance
        nextSerialNumber = newSerialNumber + 1 in
    let (sender, ledger) = whoami ledger in
    let donut : Donut = record where serialNumber = newSerialNumber in
    (change, newShop, transfer sender donut ledger)

// Consume donut and get nothing useful in return
eatDonut (donut : Donut) : Unit =
  let record {} = donut in ()

// Collects profits from shop (succeeds only for owner)
collectProfits (shop : DonutShop) (ledger : Ledger) : DonutShop * Ledger =
  let (sender, ledger) = whoami ledger in
  if shop.owner == sender then
    let profits = shop.balance in
    let newShop = record shop with balance = coinZero in
    let (_profitsId, ledger) = transfer sender profits ledger in
    (newShop, ownerCap, ledger)
  else
    (shop, ownerCap, ledger)