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
