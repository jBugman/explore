open Core.Std
open Yojson

let default d o = match o with
  | None -> d
  | Some x -> x

let inc_counter m k = Hashtbl.change m k (fun current -> Some (1 + Option.value ~default:0 current))

let to_csv s =
  let s = String.concat ~sep:"\"\"" (String.split s ~on:'"') in
  if (String.contains s ',') || (String.contains s '\n') then "\"" ^ s ^ "\"" else s

let process field folder =
  let frequencies = String.Table.create () ~size:0 in
    Array.iter (Sys.readdir folder) ~f:(fun file ->
      let open Yojson.Basic.Util in
      let path = Filename.concat folder file in
      let json = Yojson.Basic.from_file path in
      let value = json |> member field in
      match value with
      | `String "" -> ()
      | `String s -> inc_counter frequencies s
      | `Null -> failwith "Field is missing"
      | _ -> failwith "Field is not a string"
    );
  let xs = (Hashtbl.to_alist frequencies) in
  let sorted = List.sort xs ~cmp:(fun a b -> ~-(compare (snd a) (snd b))) in
  let outfile = open_out "output.csv" in
    List.iter sorted ~f:(fun pair ->
      let k = fst pair in
      let v = snd pair in
      output_string outfile ((to_csv k) ^ "," ^ string_of_int v ^ "\n")
    );
    Out_channel.close outfile

let () =
  for _ = 1 to 100 do
    process "Name" "../test_data/"
  done
