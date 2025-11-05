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

data Dynamic : Type1 where
  toDynamic : forall (A : Type1) [Typeable A], A -> Dynamic

record MyAccount where
  ...
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

