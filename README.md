# LaTeX Standard environment

This repository stores my personal preference in LaTeX design / document structure with all packages and settings set.

To load clone this repository properly, use:
```
git clone --recursive https://github.com/dschemp/latex-standard-env.git
```

## Use this template
### Installation
Goto `FONTS.md` to see what fonts need to be installed in order to compile the types of templates.

### Usage
Just start typing in the `document.tex` and compile.

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
$ docker run --rm -v /path/to/folder:/data docker-latexmk
```

By default, the container runs `latexmk -pdfxe` to compile the document with XeLaTeX.
Depending on your document, you might want to change some parameters or use a different function of `latexmk`.

You can run custom commands like this:
```
$ docker run --rm -v /path/to/folder:/data docker-latexmk -C
```
In this case all the LaTeX-related auxilliary files will be removed.

### GitHub Container Repository

![Build and push Docker Image to ghcr.io](https://github.com/dschemp/latex-standard-env/workflows/Build%20and%20push%20Docker%20Image%20to%20ghcr.io/badge.svg)

This Docker image is also available as a prebuilt image in the GitHub Container Repository named `ghcr.io/dschemp/latexmk`.

```
$ docker run --rm -v /path/to/folder:/data ghcr.io/dschemp/latexmk
```

## Using the Visual Studio Code Development Container

_This feature requires you to have Docker installed._

The development container uses my Docker image `ghcr.io/dschemp/latexmk`.

You will need the `.devcontainer` folder in the root of your workspace.
Then you can (re)open your folder with `Ctrl+P` and `>Remote-Containers: Reopen in Container`.

As of right now this is not the best solution as saving in the document does _not_ rebuild the PDF nor does rebuilding
update the included PDF viewer tab.

And it does not utilize installed fonts on the "host" system.
Fonts needed for the compilation need to be installed it not already included in the Docker image.

## Support for Podman

> Dunno ... give it a try.
