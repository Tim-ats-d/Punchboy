open Js_of_ocaml
module Html = Dom_html

let document = Html.window##.document

class palette ~(default : Js.js_string Js.t) ~(current : Js.js_string Js.t) =
  object
    val mutable current_clr = current
    method default = default
    method get_current = current_clr

    method picker =
      let res = document##createDocumentFragment in
      let input = Html.createInput ~_type:(Js.string "color") document in
      input##.id := Js.string "color-picker";
      input##.value := Js.string "#ff5351";
      input##.required := Js._true;
      ignore
      @@ Html.addEventListener input Html.Event.change
           (Html.handler (fun _ ->
                current_clr <- input##.value;
                Js._false))
           Js._false;
      Dom.appendChild res input;
      res
  end

class clickable_colored_char (elem : Html.element Js.t) ~chr ~palette =
  object (self)
    val mutable clicked = false

    initializer
    elem##.innerText := Js.string @@ String.make 1 chr;
    self#attach_event

    method attach_event =
      if not (Char.equal chr ' ') then
        ignore
        @@ Html.addEventListener elem Html.Event.click
             (Html.handler (fun _ ->
                  clicked <- not clicked;
                  self#set_color
                    (if clicked then palette#get_current else palette#default);
                  Js._false))
             Js._false

    method get = elem
    method set_color clr = elem##.style##.backgroundColor := clr
  end

let split str callback =
  String.fold_left (fun acc chr -> callback chr :: acc) [] str |> List.rev

let destroy_after_input node name callback =
  let res = Html.createDiv document in
  res##.id := Js.string "main-column";
  let input = Html.createTextarea document in
  input##.placeholder := Js.string "Type some lyrics...";
  input##.rows := 4;
  let button = Html.createInput ~_type:(Js.string "submit") document in
  button##.id := Js.string "go-button";
  button##.value := Js.string name;
  button##.onclick :=
    Html.handler (fun _ ->
        callback input##.value;
        Dom.removeChild node res;
        Js._false);
  Dom.appendChild res input;
  Dom.appendChild res button;
  res

let onload _ =
  let main =
    Js.Opt.get
      (document##getElementById (Js.string "main"))
      (fun () -> assert false)
  in
  let palette =
    new palette ~default:(Js.string "#fff") ~current:(Js.string "#ff5351")
  in
  Dom.appendChild main
    (destroy_after_input main "Go" (fun text ->
         let column = Html.createDiv document in
         column##.id := Js.string "post-input";
         let div = Html.createDiv document in
         Dom.appendChild column div;
         Dom.appendChild main column;
         Dom.appendChild main palette#picker;
         let chars =
           split (Js.to_string text) (fun chr ->
               let div = Html.createDiv document in
               div##.id := Js.string "char";
               new clickable_colored_char div ~chr ~palette)
         in
         List.iter (fun cchar -> Dom.appendChild div cchar#get) chars));

  Js._false

let () = Html.window##.onload := Html.handler onload
