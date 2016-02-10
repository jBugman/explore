module ProcessFSharp

open System.IO
open FSharp.Data
open FSharp.Data.JsonExtensions
open CsvHelper

let SUCCESS = 0
let FAIL    = 1

let checkField = function
    | None                        -> failwith "Field is missing"
    | Some (JsonValue.String "")  -> None
    | Some (JsonValue.String key) -> Some key
    | Some _                      -> failwith "Field is not a string"

let tryGetProperty field (json:JsonValue) =
    json.TryGetProperty field

let processFSharp field folder =
    try
        let frequencies =
            Directory.GetFiles(folder, "*.json")
            |> Seq.map (fun path ->
                Path.GetFullPath path
                |> JsonValue.Load
                |> tryGetProperty field
                |> checkField
            )
            |> Seq.choose id
            |> Seq.countBy id
            |> Seq.sortBy (fun (_, n) -> -n)

        use file = new StreamWriter("output.csv")
        (
            let csv = new CsvWriter(file)
            csv.Configuration.HasHeaderRecord <- false
            csv.WriteRecords frequencies
        )
        SUCCESS
    with
        | Failure ex -> eprintfn "%s" ex; FAIL
