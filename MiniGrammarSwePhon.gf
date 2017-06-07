concrete MiniGrammarSwePhon of MiniGrammar = open MiniResSwePhon, Prelude in {

  lincat
    Utt = {s : Str} ;
    Adv = {s : Str} ;
    Pol = {s : Str ; b : Bool} ;
    
    S  = {s : Str} ;
    Cl = {s : Bool => Str} ;
    VP = {verb : Verb ; compl : Agreement => Str} ;
    AP = Adjective ;
    CN = Noun ** {fd : Bool} ;
    NP = {s : Case => Str ; a : Agreement } ;
    Pron = {s : Case => Str ; n : Number} ;
    Det = {s : Bool => Gender => Str ; n : Number ; d : Definiteness} ;
    Conj = {s : Str} ;
    Prep = {s : Str} ;
    V = Verb ;
    V2 = Verb2 ;
    A = Adjective ;
    N = Noun ;
    PN = {s : Str} ;

  lin
    UttS s = s ;
    UttNP np = {s = np.s ! Nom} ;

    UsePresCl pol cl = {
      s = pol.s ++ cl.s ! pol.b
      } ;
    PredVP np vp = {
      s = \\b =>
        np.s ! Nom
        ++ case b of {
          True  => vp.verb.s ++ vp.verb.p ;
          False => vp.verb.s ++ "Int@" ++ vp.verb.p
          }
        ++ vp.compl ! np.a ;
      } ;
      
    UseV v = {
      verb = v ;
      compl = \\a => [];
      } ;
    ComplV2 v2 np = {
      verb = v2 ;
      compl = \\a => v2.c ++ np.s ! Acc;
      } ;
    UseAP ap = {
      verb = copula ;
      compl = \\a => ap.s ! a ! Indef;
      } ;
    AdvVP vp adv =
      vp ** {compl = \\a => vp.compl ! a ++ adv.s} ;

    DetCN det cn = {
      s = \\c => det.s ! cn.fd ! cn.g ++ cn.s ! det.n ! det.d ;
      a = Agr cn.g det.n
      } ;
    UsePN pn = {s = \\_ => pn.s ; a = Agr GN Sg } ;
    UsePron p = {s = p.s ; a = Agr GN p.n ; d = case p.n of {Sg => Indef ; Pl => Def}} ;
    MassNP cn = {s = \\_ => cn.s ! Sg ! Indef ; a = Agr GT Sg} ;

    a_Det     = {s = \\_ => table {GN => "En" ; GT => "Et"} ; n = Sg ; d = Indef} ;
    aPl_Det   = {s = \\_,_ => []                           ; n = Pl ; d = Indef} ;
    the_Det   = {s = table {False => \\_ => [] ; True => table {GN => "dEn" ; GT => "de"}}
                                                           ; n = Sg ; d = Def  } ;
    thePl_Det = {s = table {False => \\_ => [] ; True => \\_ => "dOm"}
                                                           ; n = Pl ; d = Def  } ;
    UseN n = n ** {fd = False};
    AdjCN ap cn = {
      s = \\n,d => ap.s ! Agr cn.g n ! d ++ cn.s ! n ! d ;
      g = cn.g ;
      fd = True
      } ;
    PositA a = a ;
    PrepNP prep np = {s = prep.s ++ np.s ! Acc} ;

    CoordS conj a b = {s = a.s ++ conj.s ++ b.s} ;

    PPos  = {s = [] ; b = True} ;
    PNeg  = {s = [] ; b = False} ;

    and_Conj = {s = "o"} ;
    or_Conj = {s = "El:@R"} ;

    every_Det = {s = \\_,_ => "v'aRj@" ; n = Sg ; d = Indef} ;

    in_Prep = {s = "i:"} ;
    on_Prep = {s = "pO:"} ;
    with_Prep = {s = "mE:"} ;

    i_Pron = {
      s = table {Nom => "jA:" ; Acc => "mEI"} ;
      n = Sg
      } ;
    youSg_Pron = {
      s = table {Nom => "du\"" ; Acc => "dEI"} ;
      n = Sg
      } ;
    he_Pron = {
      s = table {Nom => "han:" ; Acc => "h'On:Om"} ;
      n = Sg
      } ;
    she_Pron = {
      s = table {Nom => "hun:" ; Acc => "h'En:E"} ;
      n = Sg
      } ;
    we_Pron = {
      s = table {Nom => "vi:" ; Acc => "Os:"} ;
      n = Pl
      } ;
    youPl_Pron = {
      s = table {Nom => "ni:" ; Acc => "e:R"} ;
      n = Pl
      } ;
    they_Pron = {
      s = table {Nom => "dOm:" ; Acc => "dOm:"} ;
      n = Pl
      } ;

}
