open Js_of_ocaml

let doc = Dom_html.window##.document

module Widget = Widgets.Make (struct
  let doc = doc
end)

let ( <+> ) = Dom.appendChild
let ( <-> ) = Dom.removeChild

let colored_lyrics lyrics =
  let palette = new Widget.palette ~default:"fff" ~initial_clr:"#ff5351" in
  let frgmt = doc##createDocumentFragment in
  let column = Dom_html.createDiv doc in
  column##.id := Js.string "lyrics";
  let div = Dom_html.createDiv doc in
  column <+> div;
  frgmt <+> column;
  frgmt <+> palette#make_picker;
  Js.to_string lyrics |> Zed_string.of_utf8
  |> Fun.flip
       (Zed_string.fold (fun zchr acc ->
            new Widget.clickable_colored_char zchr ~palette :: acc))
       []
  |> List.rev
  |> List.iter (fun chr -> div <+> chr#node);
  frgmt

let with_click button f =
  button##.onclick :=
    Dom_html.handler (fun _ ->
        f ();
        Js._false)

let onload _ =
  let main = Dom_html.getElementById "main" in
  let main_column = Dom_html.getElementById "main-column" in
  let go_button =
    Option.get Dom_html.(getElementById_coerce "go-button" CoerceTo.input)
  in
  with_click go_button (fun () ->
      let textarea =
        Option.get
          Dom_html.(getElementById_coerce "lyrics-box" CoerceTo.textarea)
      in
      main <-> main_column;
      main <+> colored_lyrics textarea##.value);
  Js._false

let () = Dom_html.(window##.onload := handler onload)
