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
  ocamlformat
  js_of_ocaml
  js_of_ocaml-ppx
  js_of_ocaml-tyxml))
