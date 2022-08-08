open Js_of_ocaml

module Make (Document : sig
  val doc : Dom_html.document Js.t
end) =
struct
  open Document

  class palette ~default ~initial_clr =
    object
      val mutable color = Js.string initial_clr
      method color = color
      method default = Js.string default

      method make_picker =
        let picker = Dom_html.createInput ~_type:(Js.string "color") doc in
        picker##.id := Js.string "color-picker";
        picker##.value := Js.string "#ff5351";
        picker##.required := Js._true;
        picker##.onchange :=
          Dom_html.handler (fun _ ->
              color <- picker##.value;
              Js._false);
        (picker :> Dom.element Js.t)
    end

  class clickable_colored_char chr ~palette =
    object (self)
      val node =
        let div = Dom_html.createDiv doc in
        div##.id := Js.string "char";
        div

      val mutable clicked = false

      initializer
      node##.innerText := Js.string (Zed_char.to_utf8 chr);
      self#attach_event

      method private attach_event =
        if Zed_char.compare chr (Zed_char.unsafe_of_char ' ') <> 0 then
          node##.onclick :=
            Dom_html.handler (fun _ ->
                clicked <- not clicked;
                self#set_color
                  (if clicked then palette#color else palette#default);
                Js._false)

      method node = node
      method set_color clr = node##.style##.backgroundColor := clr
    end
end
