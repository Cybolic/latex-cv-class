$dvi_previewer = 'start xdvi -watchfile 1.5';
$ps_previewer  = 'start gv --watch';
$pdf_previewer = 'start evince';

@default_files = ('main.tex');
$pdf_mode = 4;        # tex -> pdf with LuaLaTeX
set_tex_cmds( '--interaction=batchmode %O %S' );
#$pdflatex = 'pdflatex -interaction=nonstopmode -shell-escape';
#$lualatex = 'lualatex -interaction=batchmode %O %S';
#$lualatex

