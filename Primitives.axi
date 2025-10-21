primitive
  // provides access to ledger and transaction metadata
  Ledger : Type1
  // a unique address of a cell or an account
  Address : Type
  // an address that signed the currently executed transaction
  whoami : Ledger -> Address * Ledger
  // create a new cell owned by a specified address
  transfer : forall (A : Type1),
    Address -> A -> Ledger -> Address * Ledger
  // destroy an existing cell owned by transaction signer
  receive : forall @(A : Type1), Address -> Ledger -> Option A * Ledger
  // create a new mutable shared cell, accessible by everyone
  share : forall (A : Type1), A -> Ledger -> Address * Ledger
  // get an owned or a shared cell and set its new version
  update : forall @(A : Type1),
    Address -> Ledger -> Option (A * (A -> Unit)) * Ledger
  // create a new immutable shared cell, accessible by everyone
  freeze : forall (A : Type), A -> Ledger -> Address * Ledger
  // read contents of an immutable cell
  peek : forall @(A : Type), Address -> Ledger -> Option A * Ledger

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
  coinAmount (coin : KhalaniCoin) : Nat * KhalaniCoin =
    (coin.amount, coin)
  coinZero = record where amount = 0
  coinMerge (coin1 coin2 : KhalaniCoin) : KhalaniCoin =
    record where amount = coin1.amount + coin2.amount
  coinSplit (amount : Nat) (coin : KhalaniCoin) :
      Option KhalaniCoin * KhalaniCoin =
    if amount <= coin.amount then
      ( some (record where amount = amount)
      , record where amount = coin.amount - amount
      )
    else
      (none, coin)
