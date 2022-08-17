open Js_of_ocaml
open Js_of_ocaml_tyxml

class palette ~default ~initial_clr =
  object
    val mutable color = Js.string initial_clr
    method color = color
    method default = Js.string default

    method make_picker : [< Html_types.input ] Tyxml_js.Html.elt =
      let open Tyxml_js in
      let html =
        Html.(
          input
            ~a:
              [
                a_input_type `Color;
                a_id "color-picker";
                a_value "#ff5351";
                a_required ();
              ]
            ())
      in
      let picker = To_dom.of_input html in
      picker##.onchange :=
        Dom_html.handler (fun _ ->
            color <- picker##.value;
            Js._false);
      html
  end

class clickable_colored_char chr ~palette =
  object (self)
    val mutable clicked = false

    val node =
      Tyxml_js.Html.(div ~a:[ a_id "char" ] [ txt (Zed_char.to_utf8 chr) ])

    method node = node
    method private node_js = Tyxml_js.(To_dom.of_div node)

    initializer
    if Zed_char.compare chr (Zed_char.unsafe_of_char ' ') <> 0 then
      self#node_js##.onclick :=
        Dom_html.handler (fun _ ->
            clicked <- not clicked;
            Printf.printf "%b\n" clicked;
            print_endline
            @@ Js.to_string (if clicked then palette#color else palette#default);
            self#set_color (if clicked then palette#color else palette#default);
            Js._false)

    method set_color clr = self#node_js##.style##.backgroundColor := clr
  end
