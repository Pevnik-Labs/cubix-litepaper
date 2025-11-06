primitive
  // Provides access to the ledger and transaction metadata.
  Ledger : Type1

  // Type of accounts, stored in account cells.
  Account : Type1

  // A unique address of a cell.
  Address : Type

  // A reference to an account cell or a shared cell.
  Ref : Type1 -> Type

  // Extract an address from a reference.
  addressof : forall (A : Type1), Ref A -> Address

  // Try to convert an address to a reference.
  referenceof : forall @(A : Type1),
    Address -> Ledger -> Option (Ref A) * Ledger

  // Return the address that signed the currently executed transaction.
  whoami : Ledger -> Ref Account * Ledger

  // Create a new cell owned by the specified account.
  new : forall (A : Type1), Ref Account -> Ledger -> Address * (A -> Ledger)

  // Destroy an existing cell owned by the transaction originator
  // and move the cell's resources into the program.
  delete : forall @(A : Type1), Address -> Ledger -> Option A * Ledger

  // Create a new mutable shared cell.
  share : forall (A : Type1), Ledger -> Ref A * (A -> Ledger)

  // Load the contents of a shared cell and then store a new value.
  update : forall (A : Type1), Ref A -> Ledger -> A * (A -> Ledger)

  // Create a new immutable shared cell.
  freeze : forall (A : Type), Ledger -> Address * (A -> Ledger)

  // Read the contents of an immutable shared cell.
  peek : forall @(A : Type), Address -> Ledger -> Option A * Ledger
