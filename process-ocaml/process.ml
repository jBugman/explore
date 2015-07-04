open Yojson

let process field folder =
  let frequencies = Hashtbl.create 0 in
  Array.iter
    (fun file ->
      let open Yojson.Basic.Util in
      let path = Filename.concat folder file in
      let json = Yojson.Basic.from_file path in
      let value = json |> member field in
      match value with
      | `String "" -> ()
      | `String s ->
        let n = try Hashtbl.find frequencies s with Not_found -> 0 in
        Hashtbl.replace frequencies s (n+1)
      | `Null -> failwith "Field is missing"
      | _ -> failwith "Field is not a string"
      )
    (Sys.readdir folder);
  Hashtbl.iter (fun k v -> print_endline (k ^ " " ^ string_of_int v)) frequencies

let () =
  match Sys.argv with
  | [|_; field; folder|] -> process field folder
  | _ -> print_string "Args are: <field name> <folder>\n"
