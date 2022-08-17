open Js_of_ocaml
open Js_of_ocaml_tyxml

class palette :
  default:string
  -> initial_clr:string
  -> object
       method color : Js.js_string Js.t
       method default : Js.js_string Js.t
       method make_picker : Html_types.input Tyxml_js.Html.elt
     end

class clickable_colored_char :
  Zed_char.t
  -> palette:palette
  -> object
       method node : Html_types.div Tyxml_js.Html.elt
       method set_color : Js.js_string Js.t -> unit
     end
