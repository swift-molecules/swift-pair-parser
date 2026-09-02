# swift-pair-parser

Focused Parser integration for the Pair domain.

`Pair Parser` makes a pair of parsers a sequential parser. `Pair.Parser`
returns both outputs as a nominal `Pair`, and `Pair(a, b).parser()` lifts an
existing pair.

Its builder rules are the fallback for value outputs that are not copyable,
which the atom's tuple-building rules cannot express. Copyable values resolve
to the atom's `Parser.Append` and never reach these rules.
