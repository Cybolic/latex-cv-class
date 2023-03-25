# CV-Cybolic

A YAML-based LaTeX setup for my CV.

This is largely compatible with the [JSON-Resume](https://github.com/jsonresume/resume-schema) format but without using all its properties and adding a few extras:

  - `personalSummary` in `basics` section. This is shown as "Personal Life" at the end of the CV if present
  - `description` in the `references` section. This is to show the title or other description of the person providing the reference

The following sections are not used: `volunteer`, `education`, `awards`, `certificates`, `publications`, `languages` and `interests`.

Also, it's using YAML instead of JSON as I find it a much better match when handling text.

## To get started

  1. Rewrite `resume-example.yaml` or change the path in the beginning of `main.tex` to point to your own YAML file.
  1. Run `make` to build the PDF file.

You can also run `make watch` to automatically recompile the PDF when the YAML file changes.

## Requirements

This requires LuaTeX and latexmk and has been tested with TeX Live 2022.
