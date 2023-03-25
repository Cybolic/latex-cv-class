default: build

cv.bbl:
	@echo "Compiling bibliography..."
	biber cv

# cv-preamble.fmt: cv.tex
# 	@echo "Compiling preamble..."
# 	luatex -ini -interaction=nonstopmode -jobname="cv-preamble" "&lualatex" mylatexformat.ltx cv-preamble.tex


build: cv.bbl #cv-preamble.fmt
	@echo "Building PDF..."
	# lualatex --interaction=batchmode --output-format=pdf '&cv-preamble' cv.tex
	lualatex --interaction=batchmode --output-format=pdf cv.tex
