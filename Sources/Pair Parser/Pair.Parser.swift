public import Either
public import Pair
public import Parser

@usableFromInline
internal func absurd<Output>(_ never: Never) -> Output {
    never
}

extension Pair::Pair
where
    First: Parser::Parser.`Protocol` & ~Copyable,
    Second: Parser::Parser.`Protocol` & ~Copyable,
    First.Input == Second.Input,
    First.Output: Escapable,
    Second.Output: Escapable
{

    // The node admits noncopyable upstream parsers and conditionally recovers
    // `Copyable` below when both upstream parsers and the failure are copyable.
    @frozen
    public struct Parser<Failure: Swift.Error>: ~Copyable {
        @usableFromInline
        internal let first: First

        @usableFromInline
        internal let second: Second

        @usableFromInline
        internal let firstFailure: (First.Failure) -> Failure

        @usableFromInline
        internal let secondFailure: (Second.Failure) -> Failure

        @inlinable
        public init(
            upstream: consuming Pair::Pair<First, Second>,
            failure: consuming Pair::Pair<
                (First.Failure) -> Failure,
                (Second.Failure) -> Failure
            >
        ) {
            self.first = upstream.first
            self.second = upstream.second
            self.firstFailure = failure.first
            self.secondFailure = failure.second
        }
    }
}

extension Pair::Pair.Parser: Copyable
where
    First: Copyable,
    Second: Copyable,
    Failure: Copyable
{}

extension Pair::Pair.Parser: Parser::Parser.`Protocol`
where First: ~Copyable, Second: ~Copyable {

    public typealias Input = First.Input

    public typealias Output = Pair::Pair<First.Output, Second.Output>

    public typealias Body = Never

    @inlinable
    public borrowing func parse(_ input: inout Input) throws(Failure) -> Output {
        let first: First.Output
        do throws(First.Failure) {
            first = try self.first.parse(&input)
        } catch {
            throw firstFailure(error)
        }

        let second: Second.Output
        do throws(Second.Failure) {
            second = try self.second.parse(&input)
        } catch {
            throw secondFailure(error)
        }

        return Pair::Pair<First.Output, Second.Output>(first, second)
    }
}

extension Pair::Pair
where
    First: Parser::Parser.`Protocol` & ~Copyable,
    Second: Parser::Parser.`Protocol` & ~Copyable,
    First.Input == Second.Input,
    First.Output: Escapable,
    Second.Output: Escapable,
    First.Failure == Never,
    Second.Failure == Never
{

    @inlinable
    public consuming func parser() -> Pair::Pair<First, Second>.Parser<Never> {
        .init(
            upstream: self,
            failure: Pair::Pair<(Never) -> Never, (Never) -> Never>(
                absurd,
                absurd
            )
        )
    }
}

extension Pair::Pair
where
    First: Parser::Parser.`Protocol` & ~Copyable,
    Second: Parser::Parser.`Protocol` & ~Copyable,
    First.Input == Second.Input,
    First.Output: Escapable,
    Second.Output: Escapable,
    First.Failure == Never
{

    @_disfavoredOverload
    @inlinable
    public consuming func parser() -> Pair::Pair<First, Second>.Parser<Second.Failure> {
        .init(
            upstream: self,
            failure: Pair::Pair<
                (Never) -> Second.Failure,
                (Second.Failure) -> Second.Failure
            >(
                { $0 },
                { $0 }
            )
        )
    }
}

extension Pair::Pair
where
    First: Parser::Parser.`Protocol` & ~Copyable,
    Second: Parser::Parser.`Protocol` & ~Copyable,
    First.Input == Second.Input,
    First.Output: Escapable,
    Second.Output: Escapable,
    Second.Failure == Never
{

    @_disfavoredOverload
    @inlinable
    public consuming func parser() -> Pair::Pair<First, Second>.Parser<First.Failure> {
        .init(
            upstream: self,
            failure: Pair::Pair<
                (First.Failure) -> First.Failure,
                (Never) -> First.Failure
            >(
                { $0 },
                { $0 }
            )
        )
    }
}

extension Pair::Pair
where
    First: Parser::Parser.`Protocol` & ~Copyable,
    Second: Parser::Parser.`Protocol` & ~Copyable,
    First.Input == Second.Input,
    First.Output: Escapable,
    Second.Output: Escapable
{

    @_disfavoredOverload
    @inlinable
    public consuming func parser() -> Pair::Pair<First, Second>.Parser<
        Either<First.Failure, Second.Failure>
    > {
        .init(
            upstream: self,
            failure: Pair::Pair<
                (First.Failure) -> Either<First.Failure, Second.Failure>,
                (Second.Failure) -> Either<First.Failure, Second.Failure>
            >(
                { .left($0) },
                { .right($0) }
            )
        )
    }
}
