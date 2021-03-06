resource MiniResSwePhon = open Prelude in {

param
  Number = Sg | Pl ;
  Case = Nom | Acc ;
  Definiteness = Indef | Def ;
  Gender = GN | GT ;
  PluralForm = Or | Ar | Er | PlN | PlX ;
  Agreement = Agr Gender Number ;

oper
  Noun : Type = {s : Number => Definiteness => Str ; g : Gender} ;

  mkNoun : Str -> Str -> Str -> Str -> Gender -> Noun = \sgindef,sgdef,plindef,pldef,g -> {
    s = table {
      Sg => table { Indef => sgindef ; Def => sgdef } ;
      Pl => table { Indef => plindef ; Def => pldef }
      } ;
    g = g
    } ;

  stem : Str -> Str = \w -> case w of {
    s + ("a" | "e" | "E" | "o" | "@") => s ;
    s + "@" + fin@("r" | "l" | "n") => s + fin ;
    _ => w
    } ;

  suffix : Str -> Str -> Str = \w,suf -> let stem = (stem w) in
    case <w,suf> of {
      -- These rules were found out by examining a list of correctly suffixed words.
      <_                          , ""                   > => w ;
      <_                          , ("a" | "@" | "o" | "U") + _> => stem + suf ;
      <_ + ("a" | "e" | "E" | "o" | "@" | "u") + (":")*, _              > => w + suf ;
      <_                          , ("t") + _            > => stem + "@" + suf ;
      <_ + ("@l" | "@r")          , _                    > => w + suf ;
      <_                          , _                    > => w + "@" + suf
      } ;

  selNT : Gender -> Str = \g -> case g of {GN => "n" ; GT => "t"} ;

  mkN = overload {
    -- Usually, the sg form and a PluralForm param is enough.
    -- Guess Gender from given PluralForm. Seems like only -er is really unpredictable.
    mkN : Str -> PluralForm -> Noun = \sg,pf -> case pf of {
      Ar  => mkNoun sg (suffix sg "n") (suffix sg "aR") (suffix sg "aRna") GN ;
      Or  => mkNoun sg (suffix sg "n") (suffix sg "UR") (suffix sg "URna") GN ;
      Er  => mkNoun sg (suffix sg "n") (suffix sg "@R") (suffix sg "@Rna") GN ;
      PlN => mkNoun sg (suffix sg "t") (suffix sg "n" ) (suffix sg "na"  ) GT ;
      PlX => mkNoun sg (suffix sg "t") sg               (suffix sg "@n"  ) GT
      } ;

    -- Default to PlX.
    mkN : Str -> Noun = \sg -> mkNoun sg (suffix sg "t") sg (suffix sg "@n") GT ;

    -- Allow specifying a Gender explicitly.
    mkN : Str -> PluralForm -> Gender -> Noun = \sg,pf,g -> case pf of {
      Ar  => mkNoun sg (suffix sg (selNT g)) (suffix sg "aR") (suffix sg "aRna") g ;
      Or  => mkNoun sg (suffix sg (selNT g)) (suffix sg "UR") (suffix sg "URna") g ;
      Er  => mkNoun sg (suffix sg (selNT g)) (suffix sg "@R") (suffix sg "@Rna") g ;
      PlN => mkNoun sg (suffix sg (selNT g)) (suffix sg "n" ) (suffix sg "na"  ) g ;
      PlX => mkNoun sg (suffix sg (selNT g)) sg               (suffix sg "@n"  ) g
      } ;

    -- Irregular plural form, regular definite forms.
    mkN : Str -> Str -> Gender -> Noun = \sg,pl,g ->
      mkNoun sg (suffix sg (selNT g)) pl (suffix pl "na") g ;

    mkN : Str -> Str -> Str -> Str -> Gender -> Noun = mkNoun ;
    } ;

  mkPN : Str -> {s : Str} = \s -> {s = s} ;

  Adjective : Type = {s : Agreement => Definiteness => Str} ;

  mkAdjective : Str -> Str -> Str -> Str -> Adjective = \n,t,sgdef,pl -> {
    s = table {
      Agr GN Sg => table {Indef => n ; Def => sgdef} ;
      Agr GN Pl => table {_ => pl} ;
      Agr GT Sg => table {Indef => t ; Def => sgdef} ;
      Agr GT Pl => table {_ => pl}
      }
    } ;

  addT : Str -> Str = \w -> case w of {
    stem + ("R" | "l") + "t" => w ;                     -- svart
    a + v@("A"|"e"|"i"|"u-"|"u"|"y"|"o"|"E"|"Y") + ":" + ("d" | "t")
                             => a + (vshort v) + "t:" ; -- rött
    _                        => w + "t"                 -- grönt
    } ;

  vshort : Str -> Str = \long -> case long of {
    "A" => "a" ;
    "e" => "E" ;
    "i" => "I" ;
    "u" => "U" ; -- O?
    "u-" => "8" ;
    "y" => "Y" ;
    "o" => "O" ;
    "E" => "E" ;
    "Y" => "W"
    } ;

  mkA = overload {
    mkA : Str -> Str -> Str -> Str -> Adjective = mkAdjective ;
    mkA : Str -> Str -> Str -> Adjective = \n,t,a -> mkAdjective n t a a ;
    mkA : Str -> Adjective = \n -> mkAdjective n (addT n) (n + "a") (n + "a") ;
    } ;

  -- p: particle e.g. "lär ut"
  Verb : Type = {s : Str ; p : Str} ;

  mkVerb : Str -> Verb = \w -> case w of {
    pres + " " + p => {s = pres ; p = p} ;
    pres => {s = pres ; p = []}
    };

  mkV : Str -> Verb = mkVerb ;

  Verb2 : Type = Verb ** {c : Str} ;

  mkV2 = overload {
    mkV2 : Str        -> Verb2 = \s   -> (mkV s) ** {c = []} ;
    mkV2 : Str -> Str -> Verb2 = \s,p -> (mkV s) ** {c = p} ;
    } ;

  copula : Verb = mkV "e:" ;

  mkAdv : Str -> {s : Str} = \s -> {s = s} ;

}
