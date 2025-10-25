primitive
  // provides access to ledger and transaction metadata
  Ledger : Type1

  // a unique address of a cell or an account
  Address : Type

  // an address that signed the currently executed transaction
  whoami : Ledger -> Address * Ledger

  // create a new cell owned by a specified address
  new : forall (A : Type1), Address -> Ledger -> Address * (A -> Ledger)

  // destroy an existing cell owned by transaction signer
  delete : forall @(A : Type1), Address -> Ledger -> Option A * Ledger

  // reference to a shared cell
  Ref : Type1 -> Type

  // create a new mutable shared cell, accessible by everyone
  share : forall (A : Type1), Ledger -> Ref A * (A -> Ledger)

  // load contents of a shared cell and then store a new value
  update : Ref A -> Ledger -> A * (A -> Ledger)

  // upcast a reference to an address
  addressof : forall (A : Type1), Ref A -> Address

  // downcast an address to a reference
  referenceof : forall @(A : Type1),
    Address -> Ledger -> Option (Ref A) * Ledger

  // create a new immutable shared cell, accessible by everyone
  freeze : forall (A : Type), A -> Ledger -> Address * Ledger

  // read contents of an immutable cell
  peek : forall @(A : Type), Address -> Ledger -> Option A * Ledger
