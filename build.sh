#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1

pdflatex -synctex=1 -interaction=nonstopmode cv.tex
