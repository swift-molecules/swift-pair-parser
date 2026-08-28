import Either
import Pair
import Parser
import Parser_Pair
import Testing

@Suite
struct `Pair as Parser` {

    @Test
    func `parses sequentially and returns both outputs`() throws(any Swift.Error) {
        var input: Substring = "abc"

        let output = try Pair(Literal("a"), Literal("b")).parse(&input)

        #expect(output.0 == "a")
        #expect(output.1 == "b")
        #expect(input == "c")
    }

    @Test
    func `attributes a first-parser failure to the left`() {
        var input: Substring = "xbc"

        do {
            _ = try Pair(Literal("a"), Literal("b")).parse(&input)
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
            _ = try Pair(Literal("a"), Literal("b")).parse(&input)
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
}

private enum LiteralError: Error {
    case expected(Character)
}

private struct Literal: Parser.`Protocol` {
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
