module ProcessFSharpTests

open NUnit.Framework
open FsUnit
open ProcessFSharp

[<TestFixture>]
type ProcessFSharpTest() =

    [<Test>]
    member this.ShouldWork() =
        processFSharp "Name" "../../test_data" |> should equal SUCCESS
