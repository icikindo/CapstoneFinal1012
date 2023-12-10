//
//  Lexicon.swift
//  Capstone3
//
//  Created by hastu on 05/11/23.
//

protocol Vocabulary {
    func addVocab(_ text: String)
    func loadSuggestions() -> [String]
}

/// The `Lexicon` object manages the list of words
actor Lexicon {

    /// Source to load city names.
    let source: Vocabulary

    init(source: Vocabulary) {
        self.source = source
    }
    /// The list of city names.
    var wording: [String] {
        if let wording = listedWording {
            return wording
        }

        let suggestions = source.loadSuggestions()
        listedWording = suggestions
        return suggestions
    }

    private var listedWording: [String]?
}

extension Lexicon {
    /// Lookup is a linear time operation.
    func lookup(prefix: String) -> [String] {
        wording.filter { $0.hasCaseAndDiacriticInsensitivePrefix(prefix) }
    }
}

extension Lexicon {
  func addLexis(text: String) {
    source.addVocab(text)
  }
}
