# Original copyright: Linus Arver <linus@ucla.edu> (https://github.com/listx/texlive-docker)
## Switched to NixOS as the base image but I want to keep using Arch

FROM archlinux/archlinux as PERL_BUILDER

RUN pacman -Syw && \
    pacman -S --noconfirm \
		base-devel

RUN \
    # Install missing Perl dependency for latexindent (see
    # https://bugs.archlinux.org/task/60210). We have to first create a
    # 'builder' user because `makepkg` refuses to run as a root user, then
    # download and install the dependency from AUR.
	echo '%builder ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
	&& groupadd -g 1100 builder \
	&& useradd -m -N -u 1100 -g 1100 builder
USER builder
    # Download missing dependency.
WORKDIR /home/builder
RUN curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/perl-log-dispatch.tar.gz \
	&& tar xvf perl-log-dispatch.tar.gz \
	&& cd perl-log-dispatch \
	&& makepkg -s --noconfirm

# --------------------- Font packages ---------------------

FROM archlinux/archlinux AS FONTS

RUN pacman -Syw

##
# Install necessary tools
##
RUN pacman -S --noconfirm \
        wget \
        unzip \
        git

WORKDIR /tmp/fonts
RUN mkdir -p /usr/share/fonts

# Libertinus Serif + Sans + Mono + Keyboard
RUN wget https://github.com/alerque/libertinus/releases/download/v7.040/Libertinus-7.040.zip -O libertinus.zip
RUN unzip libertinus.zip -d libertinus
RUN mv libertinus/Libertinus-7.040/static/OTF /usr/share/fonts/libertinus

# Barlow
RUN wget https://github.com/jpt/barlow/archive/1.422.zip -O barlow.zip
RUN unzip barlow.zip -d barlow
RUN mv barlow/barlow-1.422/fonts/otf /usr/share/fonts/barlow

# Inconsolata
RUN wget https://github.com/googlefonts/Inconsolata/releases/download/v3.000/fonts_otf.zip -O inconsolata.zip
RUN unzip inconsolata.zip -d inconsolata
RUN mv inconsolata/fonts/otf /usr/share/fonts/inconsolata

# Sofia Sans
RUN git clone https://github.com/lettersoup/Sofia-Sans.git sofia-sans
RUN mv sofia-sans/fonts/otf /usr/share/fonts/sofia-sans

# Source Sans Pro
RUN wget https://fonts.google.com/download?family=Source%20Sans%20Pro -O ssp.zip
RUN unzip ssp.zip -d ssp
RUN mv ssp /usr/share/fonts/source-sans-pro

# --------------------- LaTeX Image ---------------------

FROM archlinux/archlinux

RUN \
	# Sync package databases.
	pacman -Syw \
	# Install texlive packages.
	&& pacman -S --noconfirm \
		base-devel \
		biber \
		git \
		texlive-most \
		texlive-lang \
		pygmentize \
	# Clear pacman cache.
	&& pacman -Scc --noconfirm

# We have to manually edit PATH so that the "biber" binary is readily available
# to us. Although biber itself is found only in /usr/bin/vendor_perl, we include
# other Perl-based paths for the sake of completeness. [1]
ENV PATH="/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:${PATH}"

USER root

LABEL maintainer="Daniel Schemp <git@shmp.systems>"
LABEL org.opencontainers.image.source https://github.com/dschemp/latex-standard-env

##
# Install Perl modules necessary for latexindent
##
COPY --from=PERL_BUILDER /home/builder/perl-log-dispatch/perl-log-dispatch-2.70-1-any.pkg.tar.zst /tmp/perl-log-dispatch.pkg.tar.zst
RUN pacman -U /tmp/perl-log-dispatch.pkg.tar.zst --noconfirm

##
# Fixes an error
##
RUN mktexlsr

##
# Install fonts
##
RUN mkdir -p /usr/share/fonts
COPY --from=FONTS /usr/share/fonts /usr/share/fonts

##
# Define path
##
VOLUME [ "/data" ]
WORKDIR /data

##
# only latexmk should be run. by default, "latexmk -pdfxe" is run to compile into a PDF file with XeLaTeX
##
ENTRYPOINT [ "latexmk" ]
CMD [ "-pdfxe" ]
