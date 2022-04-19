(lang dune 2.9)

(version 1.0)

(name punchboy)

(license "GPL-3.0")

(authors "The punchboy programmers")

(maintainers "tim.arnouts@protonmail.com")

(source
 (github Tim-ats-d/Punchboy))

(bug_reports "https://github.com/Tim-ats-d/Punchboy/issues")

(homepage "https://github.com/Tim-ats-d/Punchboy")

(generate_opam_files true)

(package
 (name punchboy)
 (synopsis "Drop some lyrics and highlights the rhymes with colors")
 (depends
  dune
  (ocaml
   (>= 4.13))
  (ocamlformat
   (>= 0.21.0))
  (js_of_ocaml
   (>= 4.0.0))
  (js_of_ocaml-ppx
   (>= 4.0.0))
  (js_of_ocaml-lwt
   (>= 4.0.0))))
