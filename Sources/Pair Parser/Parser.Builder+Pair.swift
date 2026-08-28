public import Pair
public import Either
public import Parser

extension Parser::Parser.Builder {

    @frozen
    public struct Sequence<
        First: Parser::Parser.`Protocol` & ~Copyable,
        Second: Parser::Parser.`Protocol` & ~Copyable,
        Third: Parser::Parser.`Protocol` & ~Copyable
    >: ~Copyable
    where
        First.Input == Input,
        Second.Input == Input,
        Third.Input == Input,
        First.Output: Escapable,
        Second.Output: Escapable,
        Third.Output: Escapable
    {
        @usableFromInline
        internal let first: First

        @usableFromInline
        internal let second: Second

        @usableFromInline
        internal let third: Third

        @inlinable
        public init(
            _ first: consuming First,
            _ second: consuming Second,
            _ third: consuming Third
        ) {
            self.first = first
            self.second = second
            self.third = third
        }
    }

    @frozen
    public struct Append<
        Accumulated: Parser::Parser.`Protocol` & ~Copyable,
        Next: Parser::Parser.`Protocol` & ~Copyable,
        each Element
    >: ~Copyable
    where
        Accumulated.Input == Input,
        Next.Input == Input,
        Accumulated.Output == (repeat each Element),
        Next.Output: Escapable
    {
        @usableFromInline
        internal let accumulated: Accumulated

        @usableFromInline
        internal let next: Next

        @inlinable
        public init(
            accumulated: consuming Accumulated,
            next: consuming Next
        ) {
            self.accumulated = accumulated
            self.next = next
        }
    }
}

extension Parser::Parser.Builder.Sequence: Parser::Parser.`Protocol` {

    public typealias Input = First.Input

    public typealias Output = (First.Output, Second.Output, Third.Output)

    public typealias Failure = Either<
        Either<First.Failure, Second.Failure>,
        Third.Failure
    >

    public typealias Body = Never

    @inlinable
    public borrowing func parse(_ input: inout Input) throws(Failure) -> Output {
        let firstOutput: First.Output
        do throws(First.Failure) {
            firstOutput = try first.parse(&input)
        } catch {
            throw .left(.left(error))
        }

        let secondOutput: Second.Output
        do throws(Second.Failure) {
            secondOutput = try second.parse(&input)
        } catch {
            throw .left(.right(error))
        }

        let thirdOutput: Third.Output
        do throws(Third.Failure) {
            thirdOutput = try third.parse(&input)
        } catch {
            throw .right(error)
        }

        return (firstOutput, secondOutput, thirdOutput)
    }
}

extension Parser::Parser.Builder.Sequence: Copyable
where First: Copyable, Second: Copyable, Third: Copyable {}

extension Parser::Parser.Builder.Append: Parser::Parser.`Protocol` {

    public typealias Input = Accumulated.Input

    public typealias Output = (repeat each Element, Next.Output)

    public typealias Failure = Either<Accumulated.Failure, Next.Failure>

    public typealias Body = Never

    @inlinable
    public borrowing func parse(_ input: inout Input) throws(Failure) -> Output {
        let output: Accumulated.Output
        do throws(Accumulated.Failure) {
            output = try accumulated.parse(&input)
        } catch {
            throw .left(error)
        }

        let nextOutput: Next.Output
        do throws(Next.Failure) {
            nextOutput = try next.parse(&input)
        } catch {
            throw .right(error)
        }

        return (repeat each output, nextOutput)
    }
}

extension Parser::Parser.Builder.Append: Copyable
where Accumulated: Copyable, Next: Copyable {}

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
    ) -> Parser::Parser.Builder<Input>.Sequence<First, Second, Next>
    where
        First.Input == Input,
        Second.Input == Input,
        Next.Input == Input,
        First.Output: Escapable,
        Second.Output: Escapable,
        Next.Output: Escapable
    {
        .init(accumulated.first, accumulated.second, next)
    }

    @inlinable
    public static func buildPartialBlock<
        First: Parser::Parser.`Protocol`,
        Second: Parser::Parser.`Protocol`,
        Third: Parser::Parser.`Protocol`,
        Next: Parser::Parser.`Protocol`
    >(
        accumulated: Parser::Parser.Builder<Input>.Sequence<
            First,
            Second,
            Third
        >,
        next: Next
    ) -> Parser::Parser.Builder<Input>.Append<
        Parser::Parser.Builder<Input>.Sequence<First, Second, Third>,
        Next,
        First.Output,
        Second.Output,
        Third.Output
    >
    where
        First.Input == Input,
        Second.Input == Input,
        Third.Input == Input,
        Next.Input == Input,
        First.Output: Copyable,
        Second.Output: Copyable,
        Third.Output: Copyable,
        Next.Output: Escapable
    {
        .init(accumulated: accumulated, next: next)
    }

    @inlinable
    public static func buildPartialBlock<
        Accumulated: Parser::Parser.`Protocol`,
        Previous: Parser::Parser.`Protocol`,
        Next: Parser::Parser.`Protocol`,
        each Element
    >(
        accumulated: Parser::Parser.Builder<Input>.Append<
            Accumulated,
            Previous,
            repeat each Element
        >,
        next: Next
    ) -> Parser::Parser.Builder<Input>.Append<
        Parser::Parser.Builder<Input>.Append<
            Accumulated,
            Previous,
            repeat each Element
        >,
        Next,
        repeat each Element,
        Previous.Output
    >
    where
        Accumulated.Input == Input,
        Previous.Input == Input,
        Next.Input == Input,
        Previous.Output: Copyable,
        Next.Output: Escapable
    {
        .init(accumulated: accumulated, next: next)
    }
}
