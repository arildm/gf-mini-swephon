#!/bin/bash
gf --make MiniLangSwe.gf MiniLangSwePhon.gf
gfcmd="gr -cat=Cl -lang=Swe | lin -lang=SwePhon"
phon=$(echo "$gfcmd" | gf --run MiniLangSwe.gf MiniLangSwePhon.gf)
echo $phon
espeak -v sv --ipa "[[$phon]]"
