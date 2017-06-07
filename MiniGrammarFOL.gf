concrete MiniGrammarFOL of MiniGrammar = {
  lincat
    S, Cl, VP, NP, Pron, V = {s : Str} ;

  lin
    PredVP np vp = {s = (vp.s ++ "(" ++ np.s ++ ")")} ;

    UseV v = v ;

    UsePron p = p ;

    we_Pron = {s = "we"} ;
}
