#!/bin/bash
STATUS=0
LATEX_OPTIONS='-synctex=1 -interaction=nonstopmode -halt-on-error -file-line-error -pdf'

TEX_FILE="$1"
TIMEOUT=20

clean_files(){
    local TEX_DIR=$(dirname "$1")
    echo 'Cleaning files ...'
    rm "$TEX_DIR"/*.pdf "$TEX_DIR"/*.dvi "$TEX_DIR"/*.synctex.gz &> /dev/null
    find "$TEX_DIR" -type f \( \
        -name '*.bbl' -o -name '*.blg' -o -name '*.aux' -o \
        -name '*.idx' -o -name '*.ind' -o -name '*.lof' -o \
        -name '*.log' -o -name '*.log_bibtex' -o \
        -name '*.lot' -o -name '*.toc' -o -name '*.out' -o \
        -name '*.acn' -o -name '*.acr' -o -name '*.alg' -o \
        -name '*.glg' -o -name '*.glo' -o -name '*.gls' -o \
        -name '*.ist' -o -name '*.fls' -o -name '*.lol' -o \
        -name '*.fdb*' \
        \) -exec rm {} \; 
}

latexmk $LATEX_OPTIONS "$TEX_FILE" || (    
    clean_files "$TEX_FILE"
    latexmk $LATEX_OPTIONS -C "$TEX_FILE" &> /dev/null
    latexmk $LATEX_OPTIONS "$TEX_FILE"    
)