// KhalaniCoin : Type1 is a resource type that we'll define later.

coinForgery (x : KhalaniCoin) : KhalaniCoin = coinMerge x x
//           ^                                          ^ ^
//           |                                          | |
//           \------------------------------------\     | |
//                                                |     | |
// Type error: duplicate use of the resource 'x' -/     | |
// of type 'KhalaniCoin : Type1'                        | |
// First use -------------------------------------------/ |
// Second use --------------------------------------------/
// Hint: remove the duplicate use
// or declare the type to be in 'Type+' or 'Type' to allow it

coinBlackhole (x : KhalaniCoin) : Unit = ()
//             ^                         ^
//             |                         |
//             \--------------------\    |
//                                  |    |
// Type error: unused resource 'x' -/    |
// of type 'KhalaniCoin : Type1'         |
// Hint: use the resource in body -------/
// or declare the type to be in 'Type?' or 'Type' to allow it
