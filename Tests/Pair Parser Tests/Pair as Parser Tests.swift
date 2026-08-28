import Either
import Pair
import Parser
import Pair_Parser
import Testing

@Suite
struct `Pair as Parser` {

    @Test
    func `parses sequentially and returns both outputs`() throws(any Swift.Error) {
        var input: Substring = "abc"

        let output = try Pair::Pair(Literal("a"), Literal("b")).parse(&input)

        #expect(output.0 == "a")
        #expect(output.1 == "b")
        #expect(input == "c")
    }

    @Test
    func `attributes a first-parser failure to the left`() {
        var input: Substring = "xbc"

        do {
            _ = try Pair::Pair(Literal("a"), Literal("b")).parse(&input)
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
    func `attributes a second-parser failure to the right`() {
        var input: Substring = "axc"

        do {
            _ = try Pair::Pair(Literal("a"), Literal("b")).parse(&input)
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
    func `Parser Builder sequences two parsers as a Pair`() throws(any Swift.Error) {
        var input: Substring = "abc"

        let output = try twoLiterals().parse(&input)

        #expect(output.0 == "a")
        #expect(output.1 == "b")
        #expect(input == "c")
    }

    @Test
    func `Parser Builder flattens three parser outputs`() throws(any Swift.Error) {
        var input: Substring = "abcd"

        let output = try threeLiterals().parse(&input)

        #expect(output.0 == "a")
        #expect(output.1 == "b")
        #expect(output.2 == "c")
        #expect(input == "d")
    }

    @Test
    func `Parser Builder appends to an accumulated tuple pack`() throws(any Swift.Error) {
        var input: Substring = "abcde"

        let output = try fourLiterals().parse(&input)

        #expect(output.0 == "a")
        #expect(output.1 == "b")
        #expect(output.2 == "c")
        #expect(output.3 == "d")
        #expect(input == "e")
    }

    @Test
    func `Parser Builder preserves move-only tuple outputs`() throws(any Swift.Error) {
        var input: Substring = "abcd"

        let output = try threeTokens().parse(&input)
        let (first, second, third) = output

        #expect(first.value == "a")
        #expect(second.value == "b")
        #expect(third.value == "c")
        #expect(input == "d")
    }
}

@Parser::Parser.Builder<Substring>
private func twoLiterals() -> Pair::Pair<Literal, Literal> {
    Literal("a")
    Literal("b")
}

private typealias ThreeLiterals = Parser::Parser.Builder<Substring>.Sequence<
    Literal,
    Literal,
    Literal
>

@Parser::Parser.Builder<Substring>
private func threeLiterals() -> ThreeLiterals {
    Literal("a")
    Literal("b")
    Literal("c")
}

private typealias FourLiterals = Parser::Parser.Builder<Substring>.Append<
    ThreeLiterals,
    Literal,
    Character,
    Character,
    Character
>

@Parser::Parser.Builder<Substring>
private func fourLiterals() -> FourLiterals {
    Literal("a")
    Literal("b")
    Literal("c")
    Literal("d")
}

private struct Token: ~Copyable {
    let value: Character
}

private struct TokenLiteral: Parser::Parser.`Protocol` {
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

private typealias ThreeTokens = Parser::Parser.Builder<Substring>.Sequence<
    TokenLiteral,
    TokenLiteral,
    TokenLiteral
>

@Parser::Parser.Builder<Substring>
private func threeTokens() -> ThreeTokens {
    TokenLiteral(expected: "a")
    TokenLiteral(expected: "b")
    TokenLiteral(expected: "c")
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
