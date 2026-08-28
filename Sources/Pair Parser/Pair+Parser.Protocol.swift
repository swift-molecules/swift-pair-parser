public import Either
public import Pair
public import Parser

extension Pair::Pair: @retroactive Parser::Parser.`Protocol`
where
    First: Parser::Parser.`Protocol`,
    Second: Parser::Parser.`Protocol`,
    First.Input == Second.Input
{

    public typealias Input = First.Input

    public typealias Output = (First.Output, Second.Output)

    public typealias Failure = Either<First.Failure, Second.Failure>

    public typealias Body = Never

    @inlinable
    public borrowing func parse(_ input: inout Input) throws(Failure) -> Output {
        let o0: First.Output
        do throws(First.Failure) {
            o0 = try first.parse(&input)
        } catch {
            throw .left(error)
        }
        let o1: Second.Output
        do throws(Second.Failure) {
            o1 = try second.parse(&input)
        } catch {
            throw .right(error)
        }
        return (o0, o1)
    }
}
