public import Pair
public import Parser

extension Parser::Parser.Builder {

    @inlinable
    public static func buildBlock<P0: Parser::Parser.`Protocol`, P1: Parser::Parser.`Protocol`>(
        _ p0: P0,
        _ p1: P1
    ) -> Pair::Pair<P0, P1>
    where P0.Input == Input, P1.Input == Input {
        Pair::Pair(p0, p1)
    }

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
}
