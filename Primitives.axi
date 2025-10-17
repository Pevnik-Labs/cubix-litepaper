primitive
  // provides access to ledger and transaction metadata
  Ledger : Type1
  // each cell and user has a unique address
  Address : Type
  // an address that signed the currently executed transaction
  whoami : Ledger -> Address * Ledger
  // `transfer` creates a new owned cell, owned by a specified address
  transfer : forall (A : Type1), Address -> A -> Ledger -> Address * Ledger
  // `receive` destructs an existing cell owned by transaction signer
  receive : forall @(A : Type1), Ledger -> Maybe A * Ledger
  // `share` creates a new mutable, shared cell, accessible by everyone
  share : forall (A : Type1), A -> Ledger -> Address * Ledger
  // `update` accesses an owned or shared cell but requires a new version back
  update : forall @(A : Type1), Address -> Ledger -> Maybe (A * (A -> Unit)) * Ledger
  // `freeze` creates a new immutable cell, accessible by everyone
  freeze : forall (A : Type), A -> Ledger -> Address * Ledger
  // `peek` provides contents of an immutable object
  peek : forall @(A : Type), Address -> Ledger -> Maybe A * Ledger