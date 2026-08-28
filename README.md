Integration of the Parser domain with the Pair domain.

`Parser Pair` makes a pair of parsers a sequential parser. It returns both
outputs as a tuple and identifies whether the first or second parser failed by
wrapping their failure in `Either`.
