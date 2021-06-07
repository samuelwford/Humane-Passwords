//
//  Generator.swift
//  Humane Passwords
//
//  Created by Samuel Ford on 6/7/21.
//

import Foundation

// Psuedo English Word Generator
// -----------------------------
// Constructs a random password that with an English-like structure by randomly combining
// alternating vowel & consontant graphemes.
//
// The list of graphemes used is from the English orthography page on Wikipedia (see:
// https://en.wikipedia.org/wiki/English_orthography#Sound_to_spelling_correspondences).

// graphemes

struct PasswordOptions: OptionSet {
    let rawValue: Int
    
    static let numerals = PasswordOptions(rawValue: 1 << 0)
    static let capitals = PasswordOptions(rawValue: 1 << 1)
    static let symbols  = PasswordOptions(rawValue: 1 << 2)
    
    static let all: PasswordOptions = [.numerals, .capitals, .symbols]
}

private struct GraphemeOptions: OptionSet {
    let rawValue: Int
    
    static let consonant    = GraphemeOptions(rawValue: 1 << 0)
    static let vowel        = GraphemeOptions(rawValue: 1 << 1)
    static let interstitial = GraphemeOptions(rawValue: 1 << 2)
}

private struct Grapheme {
    let string: String
    let options: GraphemeOptions
    
    var isDigraph: Bool {
        string.count > 1
    }
    
    var isVowel: Bool {
        options.contains(.vowel)
    }
    
    var isConsontant: Bool {
        !isVowel
    }
    
    func same(as other: Grapheme) -> Bool {
        both(a: self, b: other, contain: .vowel) || both(a: self, b: other, contain: .consonant)
    }
    
    func both(a: Grapheme, b: Grapheme, contain: GraphemeOptions) -> Bool {
        a.options.contains(contain) && b.options.contains(contain)
    }
}

// vowels:
private let vowels = ["a", "aa", "ah", "ae", "ai", "ao", "au", "ay", "e", "ea", "ee", "ei", "ey", "eo", "eu", "i", "ie", "o", "oa", "oe", "oi", "oo", "ou", "oy", "u", "ue", "ui", "uu", "uy", "y"]
    .map { Grapheme(string: $0, options: .vowel) }


// consonants:
private let consonants = ["b", "c", "ch", "d", "f", "g", "gh", "h", "j", "k", "kn", "l", "m", "n", "p", "qu", "r", "re", "rh", "s", "sc", "sch", "sh", "sw", "t", "th", "v", "w", "wh", "wr", "x", "y", "z", "zh", "ed", "es", "ex", "sle", "el", "le", "ce", "se", "ow", "aw"]
    .map { Grapheme(string: $0, options: .consonant) }

// interstitial consonants:
private let interstitials = ["bb", "cc", "ck", "dd", "dh", "dg", "ff", "gg", "kk", "ll", "mm", "nn", "ng", "pp", "pph", "rr", "ss", "tt", "tch", "vv", "xc", "xh", "zz", "lf", "lk", "lm", "lt", "cqu", "ld"]
    .map { Grapheme(string: $0, options: [.consonant, .interstitial]) }

private let graphemes = vowels + consonants + interstitials
private let numerals  = "0123456789"
private let symbols   = "`~!@#$%^&*()-_=+[]\\{}|;':\",./<>?"

func psuedoEnglishPassword(length: Int, options: PasswordOptions) -> String {
    var password: String
    var optionsToApply: PasswordOptions

    repeat {
        password = ""
        optionsToApply = options
        
        var previsouGrapheme: Grapheme? = nil
        
        while password.count < length {
            let grapheme = graphemes.randomElement()!
                        
            if let previous = previsouGrapheme {
                // we're not at the start, maybe append a number, if requested
                if options.contains(.numerals) && probability(0.33) {
                    password.append(numerals.randomElement()!)
                    optionsToApply.remove(.numerals)
                    previsouGrapheme = nil
                    continue
                }
                
                // we're not at the start, maybe append a symbol, if requested
                if options.contains(.symbols) && probability(0.2) {
                    password.append(symbols.randomElement()!)
                    optionsToApply.remove(.symbols)
                    previsouGrapheme = nil
                    continue
                }
                
                // don't stack digraphs of the same type
                if previous.same(as: grapheme) && grapheme.isDigraph {
                    continue
                }
                
                // prefer to alternate consontant/vowel with slight preference for vowel/vowel
                if previous.same(as: grapheme) {
                    if previous.isVowel && probability(0.5) {
                        continue
                    }
                    
                    if previous.isConsontant && probability(0.9) {
                        continue
                    }
                }
            } else if grapheme.options.contains(.interstitial) {
                // no previous, so first grapheme; don't start with an interstition
                continue
            } else if password.count + grapheme.string.count > length {
                // would make the password too long, try again
                continue
            }
            
            if options.contains(.capitals) && probability(0.2) {
                password.append(grapheme.string.initialCapitalized)
                optionsToApply.remove(.capitals)
            } else {
                password.append(grapheme.string)
            }
                        
            previsouGrapheme = grapheme
        }
        
    } while !optionsToApply.intersection(.all).isEmpty
    
    return password
}

extension String {
    var initialCapitalized: String {
        prefix(1).capitalized + dropFirst()
    }

}

func probability(_ threshold: Double) -> Bool {
    Double.random(in: 0...1.0) <= threshold
}
