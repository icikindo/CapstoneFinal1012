//
//  StringEtc.swift
//  CapstoneFinal
//
//  Created by hastu on 06/12/23.
//

import Foundation
import SwiftUI

extension String {
    func hasCaseAndDiacriticInsensitivePrefix(_ prefix: String) -> Bool {
        guard let range = self.range(of: prefix, options: [.caseInsensitive, .diacriticInsensitive]) else {
            return false
        }
        return range.lowerBound == startIndex
    }

    func unCamelCased() -> String {
        return unicodeScalars.dropFirst().reduce(String(prefix(1))) {
            return CharacterSet.uppercaseLetters.contains($1)
            ? $0 + " " + String($1)
            : $0 + String($1)
        }
    }

    func formatDate() -> String {
        @AppStorage("language") var language = LocalizationService.shared.language
        let released = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd"
        let date = dateFormatter.date(from: released) ?? Date.now

        if language != userDefaultLanguage {
            dateFormatter.locale = Locale(identifier: language.rawValue)
        } else {
            dateFormatter.locale = Locale(identifier: "en_GB")
        }
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMdyyyy")
        return dateFormatter.string(from: date)
    }
}
