open Js_of_ocaml
open Js_of_ocaml_tyxml

class palette ~default ~initial_clr =
  object
    val mutable color = Js.string initial_clr
    method color = color
    method default = Js.string default

    method make_picker : [< Html_types.input ] Tyxml_js.Html.elt =
      let html =
        Tyxml_js.(
          Html.(
            input
              ~a:
                [
                  a_input_type `Color;
                  a_id "color-picker";
                  a_value "#ff5351";
                  a_required ();
                ]
              ()))
      in
      let picker = Tyxml_js.To_dom.of_input html in
      picker##.onchange :=
        Dom_html.handler (fun _ ->
            color <- picker##.value;
            Js._false);
      html
  end

class clickable_colored_char chr ~palette =
  object (self)
    val node =
      Tyxml_js.Html.(div ~a:[ a_id "char" ] [ txt (Zed_char.to_utf8 chr) ])

    method node = node
    method private node_js = Tyxml_js.(To_dom.of_div node)
    val mutable clicked = false

    initializer
    if Zed_char.compare chr (Zed_char.unsafe_of_char ' ') <> 0 then
      self#node_js##.onclick :=
        Dom_html.handler (fun _ ->
            clicked <- not clicked;
            self#set_color (if clicked then palette#color else palette#default);
            Js._false)

    method set_color clr = self#node_js##.style##.backgroundColor := clr
  end
