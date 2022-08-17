open Js_of_ocaml
open Js_of_ocaml_tyxml

let ( <+> ) = Dom.appendChild
let ( <-> ) = Dom.removeChild

let colored_lyrics lyrics =
  let palette = new Widgets.palette ~default:"fff" ~initial_clr:"#ff5351" in
  let chars =
    Js.to_string lyrics |> Zed_string.of_utf8
    |> Fun.flip
         (Zed_string.fold (fun zchr acc ->
              (new Widgets.clickable_colored_char zchr ~palette)#node :: acc))
         []
    |> List.rev
  in
  Tyxml_js.(
    To_dom.of_div
      Html.(
        div ~a:[]
          [
            div
              ~a:[ a_id "lyrics" ]
              [ div ~a:[] chars; div ~a:[] [ palette#make_picker ] ];
          ]))

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
