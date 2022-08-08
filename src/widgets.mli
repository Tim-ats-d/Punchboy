open Js_of_ocaml

module Make : functor
  (Document : sig
     val doc : Dom_html.document Js.t
   end)
  -> sig
  class palette :
    default:string
    -> initial_clr:string
    -> object
         method default : Js.js_string Js.t
         method color : Js.js_string Js.t
         method make_picker : Dom.element Js.t
       end

  class clickable_colored_char :
    Zed_char.t
    -> palette:palette
    -> object
         method node : Dom_html.divElement Js.t
         method set_color : Js.js_string Js.t -> unit
       end
end
