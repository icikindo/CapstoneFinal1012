//
//  VocabList.swift
//  Capstone3
//
//  Created by hastu on 05/11/23.
//

import Foundation
import UIKit

public class Singleton {
    var listOfWords: [String] = []
    static let shared = Singleton()
}

struct VocabList: Vocabulary {
  func addVocab(_ paragraph: String) {
    var suggested = Singleton.shared.listOfWords
    let keywords = paragraph.components(separatedBy: [",", " ", "!", ".", ":", ";", "=", "+", "/", "?", "\n", "'", "`"]).filter({$0.count > 2})
      for keyword in keywords {
          let key = keyword.lowercased()
          if !suggested.contains(key) {
              suggested.append(key)
          }
      }
      suggested.sort()
      Singleton.shared.listOfWords = suggested
  }

  func loadSuggestions() -> [String] {
    return Singleton.shared.listOfWords
  }
}
