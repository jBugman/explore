open ProcessFSharp

[<EntryPoint>]
let main argv =
    let args = argv |> List.ofSeq
    match args with
    | [field; folder] -> processFSharp field folder
    | _               -> eprintfn "Args are: <field name> <folder>"; FAIL

(* Benchmark *)
(* [<EntryPoint>]
let main argv =
    for i in 1..100 do
        processFSharp "Name" "../test_data/" |> ignore
    SUCCESS *)
