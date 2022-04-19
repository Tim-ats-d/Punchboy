open Import

let document = Html.window##.document

module Elem = Element.Make (struct
  let document = document
end)

let split str callback =
  String.fold_left (fun acc chr -> callback chr :: acc) [] str |> List.rev

let onload _ =
  let main =
    Js.Opt.get
      (document##getElementById (Js.string "main"))
      (fun () -> assert false)
  in
  let palette =
    new Elem.palette ~default:(Js.string "#fff") ~current:(Js.string "#ff5351")
  in
  Dom.appendChild main
    (Elem.destroy_after_input main "Go" (fun text ->
         let column = Html.createDiv document in
         column##.id := Js.string "post-input";
         let div = Html.createDiv document in
         Dom.appendChild column div;
         Dom.appendChild main column;
         Dom.appendChild main palette#make_picker;
         let chars =
           split (Js.to_string text) (fun chr ->
               let div = Html.createDiv document in
               div##.id := Js.string "char";
               new Elem.clickable_colored_char div chr ~palette)
         in
         List.iter (fun cchar -> Dom.appendChild div cchar#get) chars));

  Js._false

let () = Html.window##.onload := Html.handler onload
