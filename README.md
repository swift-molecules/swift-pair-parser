# swift-pair-parser

Focused Parser integration for the Pair domain.

`Pair Parser` makes a pair of parsers a sequential parser. It returns both
outputs as a nominal `Pair` through `Pair.Parser`.

Failure is normalized exactly: two fallible parsers use `Either`, while a
`Never` component is eliminated rather than retained in the public failure
type. The focused Parser builder integration sequences exactly two parsers.
N-ary product sequencing belongs to `swift-product-parser` and remains
compiler-gated until Swift parameter packs support noncopyable elements.
