# swift-pair-parser

Focused Parser integration for the Pair domain.

`Pair Parser` makes a pair of parsers a sequential parser. `Pair.Parser`
returns both outputs as a nominal `Pair`, and `Pair(a, b).parser()` lifts an
existing pair.

The builder rules for two value-producing elements live here: their failures
join as `Either`, or collapse to the shared type when both children throw the
same error. Longer sequences nest `Pair` to the left.
