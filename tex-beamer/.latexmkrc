# use XeLaTeX to compile document
$pdflatex = "xelatex %O %S";

# tex -> pdf
$pdf_mode = 1;

# don't create ps or dvi file
$postscript_mode = $dvi_mode = 0;

# default to document.tex for compiling
@default_files = ('document.tex');
