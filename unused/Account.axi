primitive
  // Provides access to the ledger and transaction metadata.
  Ledger : Type1

  // Type of accounts, stored in account cells.
  Account : Type1

  // Type of account tokens, usually stored a field of an account cells.
  AccountToken : Type1

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
  transactor : Ledger -> Ref Account * Ledger

  // Create a new cell owned by the specified account.
  new : forall (A : Type1), Ref Account -> Ledger -> Address * (A -> Ledger)

  // Destroy an existing cell owned by the transaction originator
  // and move the cell's resources into the program.
  delete : forall @(A : Type1),
    AccountToken -> Address -> Ledger -> AccountToken * Option A * Ledger

  mask : (Ledger -> Ledger) -> Ledger -> Ledger

  // Create a new mutable shared cell.
  share : forall (A : Type1), Ledger -> Ref A * (A -> Ledger)

  // Load the contents of a shared cell and then store a new value.
  update : forall (A : Type1), Ref A -> Ledger -> A * (A -> Ledger)

  // Create a new immutable shared cell.
  freeze : forall (A : Type), Ledger -> Address * (A -> Ledger)

  // Read the contents of an immutable shared cell.
  peek : forall @(A : Type), Address -> Ledger -> Option A * Ledger

record TransactionMetadata : Type where
  protocolVersion : Nat
  accountAddress : Address // "principal"
  nonce : Nat
  targetEpoch : Nat
  expiration : Nat
  ancestors : List TransactionHash

record TransactionBatch : Type where
  metadata : TransactionMetadata
  payload : Bytes
  signature : Bytes

record SelfSpawnTransaction : Type where
  metadata : TransactionMetadata
  paymentAddress : Address
  constructorCall : FunctionCall

record GasInfo : Type where
  gasLimit : GasLimit
  gasPrice : GasPrice
  gasPayment : List Address

trait Account (A : Type1) where
  Action : Type
  // 'verifyTransactionBatch' has to return the account unchanged
  verifyTransactionBatch :
    forall
    @(transactionBatch : TransactionBatch)
    @(account : A),
    Option (GasInfo * List Action) * A
  buildTransaction :
    forall
    @(action : Action)
    @(account : A)
    @(ledger : Ledger),
    ElaboratedScript * A * Ledger

trait HasTransfer (A : Type1) where
  transfer : forall (B : Type1) [Typeable B],
    A -> Either A (Address * (B -> A))

primitive
  ElaboratedPackage : Type
  deploy : ElaboratedPackage -> Ledger -> Address * Ledger
  loadPackage : Address -> Ledger -> Option ElaboratedPackage * Ledger
  packageAddress : ElaboratedPackage -> Address
  ElaboratedModule : Type
  packageModules : ElaboratedPackage -> List ElaboratedModule
  readModule : Bytes -> ElaboratedModule
  simpleMain : Quote (Ledger -> Ledger) -> ElaboratedScript

primitive
  eval : forall (A : Type1), Quote A -> A
  dynamicCall : FunctionCall -> Ledger -> Ledger
  // Modify a private cell without changing its address.
  modify : forall @(A : Type1), Address -> Ledger ->
    Either Ledger (A * (A -> Ledger))
  // Read a private cell.
  read : forall @(A : Type1), Address -> Ledger ->
    Option (Box0 A) * Ledger

data Dynamic : Type1 where
  toDynamic : forall (A : Type1) [Typeable A], A -> Dynamic

record MyAccount where
  ...
  token : Option AccountToken
  vault : HashMap Address Dynamic

instance Account MyAccount where
  parse bytes account = ...

instance HasTransfer MyAccount
  transfer obj account =
    let (addr, vault) = HM.freshAddress account.vault in
    Right
      ( addr
      , \obj ->
          record account where
            vault = HM.insert addr (toDynamic obj) account.vault
      )

buyDonutLedger : Args -> Ref DonutShop -> Ledger -> Returns * Ledger
buyDonutLedger args ref ledger =
  let
    (shop, setShop) = update ref ledger
    ledger = setShop (record shop where stuff = none)
    (stuff, ledger) = someOtherServiceProcedure stuff shop.otherServRef ledger
    (_, setShop) = update ref ledger
    ledger = setShop (record shop where stuff = stuff)
  in
  ledger
