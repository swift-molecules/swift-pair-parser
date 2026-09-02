public import Either
public import Pair
public import Parser
public import Parser_Skip

extension Parser::Parser.Builder where Input: ~Copyable & ~Escapable {

    @inlinable
    public static func buildPartialBlock<A: Parser::Parser.`Protocol`, N: Parser::Parser.`Protocol`>(
        accumulated: A,
        next: N
    ) -> Pair::Pair<A, N>.Parser<Either<A.Failure, N.Failure>>
    where
        A.Input == Input,
        N.Input == Input,
        A.Input: ~Copyable & ~Escapable,
        N.Input: ~Copyable & ~Escapable,
        A.Output: ~Copyable & Escapable,
        N.Output: ~Copyable & Escapable
    {
        .init(accumulated, next, { .left($0) }, { .right($0) })
    }

    @inlinable
    public static func buildPartialBlock<A: Parser::Parser.`Protocol`, N: Parser::Parser.`Protocol`>(
        accumulated: A,
        next: N
    ) -> Pair::Pair<A, N>.Parser<A.Failure>
    where
        A.Input == Input,
        N.Input == Input,
        A.Input: ~Copyable & ~Escapable,
        N.Input: ~Copyable & ~Escapable,
        A.Output: ~Copyable & Escapable,
        N.Output: ~Copyable & Escapable,
        A.Failure == N.Failure
    {
        .init(accumulated, next, { $0 }, { $0 })
    }

    @inlinable
    public static func buildPartialBlock<A: Parser::Parser.`Protocol`, N: Parser::Parser.`Protocol`>(
        accumulated: A,
        next: N
    ) -> Parser::Parser.Skip.First<A, N, Either<A.Failure, N.Failure>>
    where
        A.Input == Input,
        N.Input == Input,
        A.Input: ~Copyable & ~Escapable,
        N.Input: ~Copyable & ~Escapable,
        A.Output == Void,
        N.Output: ~Copyable & Escapable
    {
        Parser::Parser.Skip.First(accumulated, next, { .left($0) }, { .right($0) })
    }

    @inlinable
    public static func buildPartialBlock<A: Parser::Parser.`Protocol`, N: Parser::Parser.`Protocol`>(
        accumulated: A,
        next: N
    ) -> Parser::Parser.Skip.First<A, N, A.Failure>
    where
        A.Input == Input,
        N.Input == Input,
        A.Input: ~Copyable & ~Escapable,
        N.Input: ~Copyable & ~Escapable,
        A.Output == Void,
        N.Output: ~Copyable & Escapable,
        A.Failure == N.Failure
    {
        Parser::Parser.Skip.First(accumulated, next, { $0 }, { $0 })
    }
}
