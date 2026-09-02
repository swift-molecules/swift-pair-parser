public import Either
public import Pair
public import Parser
public import Parser_Product

extension Pair::Pair
where
    First: Parser::Parser.`Protocol`,
    Second: Parser::Parser.`Protocol`,
    First.Input == Second.Input,
    First.Input: ~Copyable & ~Escapable,
    Second.Input: ~Copyable & ~Escapable,
    First.Output: ~Copyable & Escapable,
    Second.Output: ~Copyable & Escapable
{

    @inlinable
    public consuming func parser() -> Parser::Parser.Product<First, Second, Either<First.Failure, Second.Failure>> {
        .init(first, second, { .left($0) }, { .right($0) })
    }

    @inlinable
    public consuming func parser() -> Parser::Parser.Product<First, Second, First.Failure>
    where First.Failure == Second.Failure {
        .init(first, second, { $0 }, { $0 })
    }
}
