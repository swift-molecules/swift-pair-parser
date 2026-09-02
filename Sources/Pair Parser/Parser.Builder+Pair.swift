public import Either
public import Pair
public import Parser

extension Parser::Parser.Builder {

    @_disfavoredOverload
    @inlinable
    public static func buildBlock<
        First: Parser::Parser.`Protocol`,
        Second: Parser::Parser.`Protocol`
    >(
        _ first: First,
        _ second: Second
    ) -> Pair::Pair<First, Second>.Parser<Never>
    where
        First.Input == Input,
        Second.Input == Input,
        First.Output: ~Copyable & Escapable,
        Second.Output: ~Copyable & Escapable,
        First.Failure == Never,
        Second.Failure == Never
    {
        Pair::Pair(first, second).parser()
    }

    @_disfavoredOverload
    @inlinable
    public static func buildBlock<
        First: Parser::Parser.`Protocol`,
        Second: Parser::Parser.`Protocol`
    >(
        _ first: First,
        _ second: Second
    ) -> Pair::Pair<First, Second>.Parser<Second.Failure>
    where
        First.Input == Input,
        Second.Input == Input,
        First.Output: ~Copyable & Escapable,
        Second.Output: ~Copyable & Escapable,
        First.Failure == Never
    {
        Pair::Pair(first, second).parser()
    }

    @_disfavoredOverload
    @inlinable
    public static func buildBlock<
        First: Parser::Parser.`Protocol`,
        Second: Parser::Parser.`Protocol`
    >(
        _ first: First,
        _ second: Second
    ) -> Pair::Pair<First, Second>.Parser<First.Failure>
    where
        First.Input == Input,
        Second.Input == Input,
        First.Output: ~Copyable & Escapable,
        Second.Output: ~Copyable & Escapable,
        Second.Failure == Never
    {
        Pair::Pair(first, second).parser()
    }

    @_disfavoredOverload
    @inlinable
    public static func buildBlock<
        First: Parser::Parser.`Protocol`,
        Second: Parser::Parser.`Protocol`
    >(
        _ first: First,
        _ second: Second
    ) -> Pair::Pair<First, Second>.Parser<
        Either<First.Failure, Second.Failure>
    >
    where
        First.Input == Input,
        Second.Input == Input,
        First.Output: ~Copyable & Escapable,
        Second.Output: ~Copyable & Escapable
    {
        Pair::Pair(first, second).parser()
    }

    @_disfavoredOverload
    @inlinable
    public static func buildPartialBlock<
        First: Parser::Parser.`Protocol`,
        Second: Parser::Parser.`Protocol`
    >(
        accumulated first: First,
        next second: Second
    ) -> Pair::Pair<First, Second>.Parser<Never>
    where
        First.Input == Input,
        Second.Input == Input,
        First.Output: ~Copyable & Escapable,
        Second.Output: ~Copyable & Escapable,
        First.Failure == Never,
        Second.Failure == Never
    {
        Pair::Pair(first, second).parser()
    }

    @_disfavoredOverload
    @inlinable
    public static func buildPartialBlock<
        First: Parser::Parser.`Protocol`,
        Second: Parser::Parser.`Protocol`
    >(
        accumulated first: First,
        next second: Second
    ) -> Pair::Pair<First, Second>.Parser<Second.Failure>
    where
        First.Input == Input,
        Second.Input == Input,
        First.Output: ~Copyable & Escapable,
        Second.Output: ~Copyable & Escapable,
        First.Failure == Never
    {
        Pair::Pair(first, second).parser()
    }

    @_disfavoredOverload
    @inlinable
    public static func buildPartialBlock<
        First: Parser::Parser.`Protocol`,
        Second: Parser::Parser.`Protocol`
    >(
        accumulated first: First,
        next second: Second
    ) -> Pair::Pair<First, Second>.Parser<First.Failure>
    where
        First.Input == Input,
        Second.Input == Input,
        First.Output: ~Copyable & Escapable,
        Second.Output: ~Copyable & Escapable,
        Second.Failure == Never
    {
        Pair::Pair(first, second).parser()
    }

    @_disfavoredOverload
    @inlinable
    public static func buildPartialBlock<
        First: Parser::Parser.`Protocol`,
        Second: Parser::Parser.`Protocol`
    >(
        accumulated first: First,
        next second: Second
    ) -> Pair::Pair<First, Second>.Parser<
        Either<First.Failure, Second.Failure>
    >
    where
        First.Input == Input,
        Second.Input == Input,
        First.Output: ~Copyable & Escapable,
        Second.Output: ~Copyable & Escapable
    {
        Pair::Pair(first, second).parser()
    }
}
