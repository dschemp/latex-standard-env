# All needed and used fonts if not through CTAN packages

### Currently used:
- [Libertinus](https://github.com/alerque/libertinus) (tex-document)
- [Barlow](https://github.com/jpt/barlow) (tex-beamer)
- [Inconsolata](https://github.com/googlefonts/Inconsolata) (tex-document, tex-beamer)

### Deprecated:
- [STIX2](https://github.com/stipub/stixfonts) (tex-document)

## Docker Compilation

For use in CI/CD or alike exists the `Dockerfile`.
This will install TeXLive with most packages already included and fonts used in this repository.

To build the image, use
```
$ docker build -t docker-latexmk .
```
This might take a while so go have a coffee, or two, or five.


To use the image, you will need to map the folder containing the `document.tex` file to `/data`:
```
$ docker run --rm -c /path/to/folder:/data docker-latexmk
```

By default, the container runs `latexmk -pdfxe` to compile the document with XeLaTeX.
Depending on your document, you might want to change some parameters or use a different function of `latexmk`.

You can run custom commands like this:
```
$ docker run --rm -c /path/to/folder:/data docker-latexmk -C
```
In this case all the LaTeX-related auxilliary files will be removed.
