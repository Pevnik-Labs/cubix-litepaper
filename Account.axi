record SimplePayload : Type where
  nonce : Nat
  gasLimit : GasLimit
  gasPrice : GasPrice
  payment : Address
  action : ElaboratedModule
  signature : Bytes

record VanillaTransaction : Type where
  protocolVersion : Nat
  accountAddress : Address
  rawPayload : Bytes

record SelfSpawnTransaction : Type where
  protocolVersion : Nat
  accountAddress : Address
  paymentAddress : Address
  constructorCall : ConstructorCall

trait Account (A : Type1) where
  Payload : Type
  parse :
    forall
    @(bytes : Bytes),
    @(account : A),
    Option Payload * A
  Nonce : Type
  happensBefore : Nonce -> Nonce -> Option Bool
  nonce : Payload -> Nonce
  verify :
    forall
    @(payload : Payload)
    @(account : A),
    Option (GasLimit * GasPrice * Address) * A
  transact :
    forall
    @(payload : Payload)
    @(gasLimit : GasLimit)
    @(gasLimit : GasPrice)
    @(account : A),
    ElaboratedModule * A

trait HasTransfer (A : Type1) where
  transfer : forall (B : Type1) [Typeable B],
    A -> Either A (Address * (B -> A))

primitive
  deploy : ElaboratedPackage -> Ledger -> Address * Ledger
  packageof : Address -> Ledger -> Option ElaboratedPackage * Ledger
  modulesof : ElaboratedPackage -> List ElaboratedModule
  readModule : Bytes -> ElaboratedModule
  simpleMain : Code (Ledger -> Ledger) -> ElaboratedModule

primitive
  eval : forall (A : Type1), Code A -> A
  dynamicCall : 

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

