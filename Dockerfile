FROM listx/texlive:2020

RUN pacman -S --noconfirm wget unzip
RUN mktexlsr

WORKDIR /tmp/fonts
RUN mkdir -p /usr/share/fonts

RUN wget https://github.com/alerque/libertinus/releases/download/v7.020/Libertinus-7.020.zip -O libertinus.zip
RUN unzip libertinus.zip -d libertinus
RUN mv libertinus/Libertinus-7.020/static/OTF /usr/share/fonts/libertinus

RUN wget https://github.com/jpt/barlow/archive/1.422.zip -O barlow.zip
RUN unzip barlow.zip -d barlow
RUN mv barlow/barlow-1.422/fonts/otf /usr/share/fonts/barlow

RUN wget https://github.com/googlefonts/Inconsolata/releases/download/v3.000/fonts_otf.zip -O inconsolata.zip
RUN unzip inconsolata.zip -d inconsolata
RUN mv inconsolata/fonts/otf /usr/share/fonts/inconsolata

VOLUME [ "/data" ]
WORKDIR /data

ENTRYPOINT [ "latexmk" ]
CMD [ "-pdfxe" ]