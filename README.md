# swift-pair-parser

Focused Parser integration for the Pair domain.

`Pair Parser` makes a pair of parsers a sequential parser. It returns both
outputs as a tuple and identifies whether the first or second parser failed by
wrapping their failure in `Either`.
