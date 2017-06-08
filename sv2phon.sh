#!/bin/bash
gf --make MiniLangSwe.gf MiniLangSwePhon.gf
swe=$1
gfcmd="p -lang=Swe \"$swe\" | lin -lang=SwePhon"
phon=$(echo "$gfcmd" | gf --run MiniLangSwe.gf MiniLangSwePhon.gf)
echo $phon
espeak -v sv --ipa "[[$phon]]"
