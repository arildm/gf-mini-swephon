#!/bin/bash
gf --make MiniLangSwePhon.gf
gfcmd="gr -cat=Cl | lin -lang=SwePhon"
phon=$(echo "$gfcmd" | gf --run MiniLangSwePhon.gf)
phon=$(./focusprocess.sh "$phon")
echo $phon
espeak -v sv --ipa "[[$phon]]"
