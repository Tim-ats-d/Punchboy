open Js_of_ocaml

module Make : functor
  (Doc : sig
     val document : Dom_html.document Js.t
   end)
  -> sig
  class palette :
    default:Js.js_string Js.t
    -> current:Js.js_string Js.t
    -> object
         method default : Js.js_string Js.t
         method get_current : Js.js_string Js.t
         method make_picker : Dom.documentFragment Js.t
       end

  class clickable_colored_char :
    Dom_html.element Js.t
    -> char
    -> palette:palette
    -> object
         method get : Dom_html.element Js.t
         method set_color : Js.js_string Js.t -> unit
       end

  val destroy_after_input :
    #Dom.node Js.t ->
    string ->
    (Js.js_string Js.t -> unit) ->
    Dom_html.divElement Js.t
end
