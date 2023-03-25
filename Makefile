default: build

watch:
	@echo "Launching previewer and starting watch of main.tex..."
	latexmk -pvc -time

build:
	@echo "Building PDF..."
	latexmk
