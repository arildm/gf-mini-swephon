# Phonetic Swedish with Grammatical Framework
Arild Matsson <br>
LT2204 Computational Syntax, University of Göteborg 2017

## Assignment

For the second assignment in this course, I have chosen to extend the mini resource grammar from the first assignment.
Rather than adding more grammatical constructions, I have translated it from Swedish text to Swedish phonetic representation.

I have been evaluating the resulting representation manually (aurally), by passing it to the open-source speech synthesizer eSpeak, and listening to the output.

TL;DR:
 
1. The alphabet used is a variant of Kirshenbaum.
2. Sentence focus is marked with an "F" and processed by focusprocess.sh

## Motivation

### Initial motivation

The initial motivation behind this idea was to explore how GF, being a framework focused on written language, could be used to handle spoken language.
From text, the first step towards speech is to phonetic representation in a writing system such as IPA.

I did a quick test, and in order to evaluate the output, I passed it to the eSpeak speech synthesizer.

### External motivation: Syntax in TTS

Testing eSpeak's native support for Swedish, I could identify a few flaws.
Some could probably be fixed best by modifying the Swedish voice, but at least two flaws would be helped by the syntactical insight that GF provides:

1. POS labels help phonemicizing homographs correctly (e.g. kort/A vs. kort/N)
2. Syntactic analysis makes for better guesses at focus placement

## Implementation clarifications

### Alphabet

The Kirshenbaum phonetic alphabet was chosen over IPA, because that is what eSpeak uses.
An additional advantage is that its character set, being a subset of ASCII, is easier to type on a keyboard.
The variant used by the Swedish eSpeak voice is implicitly listed in its [rule file](https://github.com/nvaccess/espeak/blob/master/dictsource/sv_rules).

### Focus

Focus is a challenge for TTS, since it is not explicitly marked in text.
With eSpeak, pitch drop creates an impression of focus at the last stressed syllable.
With GF, syntactic knowledge can be leveraged to better determine a reasonable focus domain.

I use a combination of a marker token and post-processing.
First, I only use secondary stress markers and not primary ones.
Second, I insert an focus token "F" before the word identified as the focus domain.
These two steps are part of the GF grammar.
Last, I use regular expression substitution on the linearization, to remove the token and change the succeeding secondary stress marker to a primary one.

Where an intransitive verb is used, I place focus on the verb, while for transitive verb phrases, I place it on the object. 

## Challenges

The Swedish voice of eSpeak does not feature the retroflex phonemes that appear in standard Swedish for combinations of some consonants with /r/.
I have simply used a separate /r/ phoneme which is clear and understandable, although not representative of standard Swedish.

The voice is also missing the distinction between acute and grave accent.
This is unfortunate, as GF would have been quite decent with handling the distinction.
For some words, specifically those where the vowel of the second syllable is "e", I have tried to reflect the grave accent by choosing a less centralized vowel for the second syllable, i.e. /ɛ/ instead of /ə/.

## Evaluation and result

I created three scripts to help me with testing the grammar.

1. randphon.sh linearizes a random clause as phonemes and passes it to eSpeak.
2. sv2phon.sh accepts a phrase in Swedish, translates it to phonemes and passes it to eSpeak.
3. focusprocess.sh is used in both of the above to convert the sentence focus marker to a primary stress marker.

An important measure of accuracy has been to compare the audio output of sv2phon.sh to that of espeak.
These are some successful examples:

1. Focus on intransitive verb

       $ ./sv2phon.sh "jag hoppar redan"
        j,A: h'Op:aR R,e:dan
        jˌɑː hˈɔpːar rˌeːdan
       $ espeak -v sv --ipa "jag hoppar redan"
        jɑːɡ hˈɔpar rˈeːdan
        
2. Homograph distinction by POS

       $ ./sv2phon.sh "ett kort kort"
        Et k,ORt k,URt
        ɛt kˌɔrt kˈʊrt
       $ espeak -v sv --ipa "ett kort kort"
        ˈɛt kˈɔt kˈɔt
        
3. Grave accent implemented as vowel quality

       $ ./sv2phon.sh "knuten är knuten"
       kn,u-:t@n e: kn'u-:tEn
        knˌʉːtən eː knˈʉːtɛn
       $ espeak -v sv --ipa "knuten är knuten"
        knˈʉtən ɛːr knˈʉtən

## References

* https://github.com/GrammaticalFramework/gf-contrib/tree/master/mini/newmini
* http://espeak.sourceforge.net/index.html
* https://linguistics.stackexchange.com/questions/3035/is-it-hard-for-software-speech-synthesisers-to-handle-ipa-if-so-why