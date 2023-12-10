//
//  AutoComplete.swift
//  Capstone3
//
//  Created by hastu on 05/11/23.
//

import Foundation
import Combine

@MainActor
final class AutocompleteObject: ObservableObject {
    @Published var suggestions: [String] =  []
    @Published var isTapped = false

    init() {}

    let delay: TimeInterval = 0.3
    private let listWords = Lexicon(source: VocabList())

    private var task: Task<Void, Never>?
    private var tesk: Task<Void, Never>?
    func addParagraph(_ text: String) {
        guard !text.isEmpty else {
            tesk?.cancel()
            return
        }
        tesk?.cancel()
        tesk = Task {
            await listWords.addLexis(text: text)
        }
    }

    func lookUp(_ text: String) {
        guard !text.isEmpty else {
            suggestions = []
            task?.cancel()
            return
        }

        task?.cancel()

        task = Task {
          try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000.0))

            guard !Task.isCancelled else {
                return
            }

            let newSuggestions = await listWords.lookup(prefix: text)

            if isSingleSuggestion(suggestions, equalTo: text) {
                // Do not offer only one suggestion same as the input
                suggestions = []
            } else {
                suggestions = newSuggestions
            }
        }
    }

    private func isSingleSuggestion(_ suggestions: [String], equalTo text: String) -> Bool {
        guard let suggestion = suggestions.first else {
            return false
        }
        return suggestion.lowercased() == text.lowercased()
    }
}
