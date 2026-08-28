import Either
import Pair
import Parser
import Pair_Parser
import Testing

@Suite
struct `Pair Parser Tests` {

    @Test
    func `parses sequentially into a nominal Pair`() throws(any Swift.Error) {
        var input: Substring = "abc"
        let parser: Pair::Pair<Literal, Literal>.Parser<
            Either<LiteralError, LiteralError>
        > = Pair::Pair(Literal("a"), Literal("b")).parser()

        let output = try parser.parse(&input)

        #expect(output.first == "a")
        #expect(output.second == "b")
        #expect(input == "c")
    }

    @Test
    func `attributes first failure to Either left`() {
        var input: Substring = "xbc"
        let parser = Pair::Pair(Literal("a"), Literal("b")).parser()

        do {
            _ = try parser.parse(&input)
            Issue.record("Expected the first parser to fail")
        } catch {
            switch error {
            case .left(.expected(let character)):
                #expect(character == "a")
            case .right:
                Issue.record("Expected a left failure")
            }
        }
    }

    @Test
    func `attributes second failure to Either right`() {
        var input: Substring = "axc"
        let parser = Pair::Pair(Literal("a"), Literal("b")).parser()

        do {
            _ = try parser.parse(&input)
            Issue.record("Expected the second parser to fail")
        } catch {
            switch error {
            case .left:
                Issue.record("Expected a right failure")
            case .right(.expected(let character)):
                #expect(character == "b")
            }
        }

        #expect(input == "xc")
    }

    @Test
    func `Never plus Never is exactly Never and requires no try`() {
        var input: Substring = "abc"
        let parser = twoNextCharacters()

        let output = parser.parse(&input)

        #expect(output.first == "a")
        #expect(output.second == "b")
        #expect(input == "c")
    }

    @Test
    func `Never plus Error is exactly Error`() throws(any Swift.Error) {
        var input: Substring = "abc"
        let parser: Pair::Pair<NextCharacter, Literal>.Parser<LiteralError> =
            Pair::Pair(NextCharacter(), Literal("b")).parser()

        let output = try parser.parse(&input)

        #expect(output.first == "a")
        #expect(output.second == "b")
        #expect(input == "c")
    }

    @Test
    func `Error plus Never is exactly Error`() throws(any Swift.Error) {
        var input: Substring = "abc"
        let parser: Pair::Pair<Literal, NextCharacter>.Parser<LiteralError> =
            Pair::Pair(Literal("a"), NextCharacter()).parser()

        let output = try parser.parse(&input)

        #expect(output.first == "a")
        #expect(output.second == "b")
        #expect(input == "c")
    }

    @Test
    func `Parser Builder sequences exactly two parsers`() throws(any Swift.Error) {
        var input: Substring = "abc"

        let output = try twoLiterals().parse(&input)

        #expect(output.first == "a")
        #expect(output.second == "b")
        #expect(input == "c")
    }

    @Test
    func `copyable upstream parsers produce a copyable Pair Parser`() {
        let parser = Pair::Pair(Literal("a"), Literal("b")).parser()

        requireCopyable(parser)
    }

    @Test
    func `noncopyable parsers produce move-only nominal Pair output`() throws(any Swift.Error) {
        var input: Substring = "abc"
        let parser = Pair::Pair(
            TokenLiteral(expected: "a"),
            TokenLiteral(expected: "b")
        ).parser()

        let output = try parser.parse(&input)
        let values = Pair::Pair<Token, Token>.apply(output) { first, second in
            (first.value, second.value)
        }

        #expect(values.0 == "a")
        #expect(values.1 == "b")
        #expect(input == "c")
    }
}

private func requireCopyable<Value: Copyable>(_ value: Value) {}

private typealias TwoLiterals = Pair::Pair<Literal, Literal>.Parser<
    Either<LiteralError, LiteralError>
>

private typealias TwoNextCharacters = Pair::Pair<
    NextCharacter,
    NextCharacter
>.Parser<Never>

@Parser::Parser.Builder<Substring>
private func twoLiterals() -> TwoLiterals {
    Literal("a")
    Literal("b")
}

@Parser::Parser.Builder<Substring>
private func twoNextCharacters() -> TwoNextCharacters {
    NextCharacter()
    NextCharacter()
}

private struct Token: ~Copyable {
    let value: Character
}

private struct TokenLiteral: ~Copyable, Parser::Parser.`Protocol` {
    typealias Input = Substring
    typealias Output = Token
    typealias Failure = LiteralError
    typealias Body = Never

    let expected: Character

    borrowing func parse(_ input: inout Substring) throws(LiteralError) -> Token {
        guard input.first == expected else { throw .expected(expected) }
        input = input.dropFirst()
        return Token(value: expected)
    }
}

private struct NextCharacter: Parser::Parser.`Protocol` {
    typealias Input = Substring
    typealias Output = Character
    typealias Failure = Never
    typealias Body = Never

    borrowing func parse(_ input: inout Substring) -> Character {
        let character = input.first!
        input = input.dropFirst()
        return character
    }
}

private enum LiteralError: Error {
    case expected(Character)
}

private struct Literal: Parser::Parser.`Protocol` {
    typealias Input = Substring
    typealias Output = Character
    typealias Failure = LiteralError
    typealias Body = Never

    let expected: Character

    init(_ expected: Character) {
        self.expected = expected
    }

    borrowing func parse(_ input: inout Substring) throws(LiteralError) -> Character {
        guard input.first == expected else { throw .expected(expected) }
        input = input.dropFirst()
        return expected
    }
}
