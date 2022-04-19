open Import

module Make (Doc : sig
  val document : Html.document Js.t
end) =
struct
  class palette ~(default : Js.js_string Js.t) ~(current : Js.js_string Js.t) =
    object
      val mutable current_clr = current
      method default = default
      method get_current = current_clr

      method make_picker =
        let res = Doc.document##createDocumentFragment in
        let input = Html.createInput ~_type:(Js.string "color") Doc.document in
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

  class clickable_colored_char (elem : Html.element Js.t) chr ~palette =
    object (self)
      val mutable clicked = false

      initializer
      elem##.innerText := Js.string @@ String.make 1 chr;
      self#attach_event

      method private attach_event =
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

  let destroy_after_input node name callback =
    let res = Html.createDiv Doc.document in
    res##.id := Js.string "main-column";
    let input = Html.createTextarea Doc.document in
    input##.placeholder := Js.string "Type some lyrics...";
    input##.rows := 4;
    let button = Html.createInput ~_type:(Js.string "submit") Doc.document in
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
end
