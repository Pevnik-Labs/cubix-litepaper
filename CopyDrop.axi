coinForgery (x : KhalaniCoin) : KhalaniCoin = coinMerge x x
//           ^                                          ^ ^
//           |                                          | |
//           \------------------------------------\     | |
//                                                |     | |
// type error: a duplicate use of a resource 'x' -/     | |
// of type 'KhalaniCoin : Type1'                        | |
// first use -------------------------------------------/ |
// second use --------------------------------------------/
// hint: remove the duplicate use
// or declare the type to be in 'Type+' or 'Type' to allow it
coinBlackhole (x : KhalaniCoin) : Unit = ()
//             ^                         ^
//             |                         |
//             \--------------------\    |
//                                  |    |
// type error: unused resource 'x' -/    |
// of type 'KhalaniCoin : Type1'         |
// hint: use the resource in body -------/
// or declare the type to be in 'Type?' or 'Type' to allow it
