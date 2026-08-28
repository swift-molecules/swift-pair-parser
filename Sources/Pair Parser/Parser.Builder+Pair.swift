public import Pair
public import Parser
public import Parser_Map

extension Parser::Parser.Builder {

    @inlinable
    public static func buildBlock<P0: Parser::Parser.`Protocol`, P1: Parser::Parser.`Protocol`>(
        _ p0: P0,
        _ p1: P1
    ) -> Pair::Pair<P0, P1>
    where P0.Input == Input, P1.Input == Input {
        Pair::Pair(p0, p1)
    }

    @_disfavoredOverload
    @inlinable
    public static func buildPartialBlock<
        Accumulated: Parser::Parser.`Protocol`,
        Next: Parser::Parser.`Protocol`
    >(
        accumulated: Accumulated,
        next: Next
    ) -> Pair::Pair<Accumulated, Next>
    where Accumulated.Input == Input, Next.Input == Input {
        Pair::Pair(accumulated, next)
    }

    @inlinable
    public static func buildPartialBlock<
        First: Parser::Parser.`Protocol`,
        Second: Parser::Parser.`Protocol`,
        Next: Parser::Parser.`Protocol`
    >(
        accumulated: Pair::Pair<First, Second>,
        next: Next
    ) -> Parser::Parser.Map<
        Pair::Pair<Pair::Pair<First, Second>, Next>,
        (First.Output, Second.Output, Next.Output)
    >
    where
        First.Input == Input,
        Second.Input == Input,
        Next.Input == Input
    {
        Pair::Pair(accumulated, next)
            .map { pair, next in
                (pair.0, pair.1, next)
            }
    }

    @inlinable
    public static func buildPartialBlock<
        Upstream: Parser::Parser.`Protocol`,
        Next: Parser::Parser.`Protocol`,
        each O,
        O2
    >(
        accumulated: Parser::Parser.Map<Upstream, (repeat each O)>,
        next: Next
    ) -> Parser::Parser.Map<
        Pair::Pair<Parser::Parser.Map<Upstream, (repeat each O)>, Next>,
        (repeat each O, O2)
    >
    where
        Upstream.Input == Input,
        Next.Input == Input,
        Next.Output == O2
    {
        Pair::Pair(accumulated, next)
            .map { tuple, next in
                (repeat each tuple, next)
            }
    }
}
