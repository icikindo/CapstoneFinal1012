//
//  SUTester.swift
//  CapstoneFinal
//
//  Created by hastu on 05/12/23.
//

import SwiftUI

enum Lang: String {
    case english = "en"
    case indonesian = "id"
}

protocol Translate {
    func localize(_ eng: String) -> String
    func stillCompatible() -> Bool
}

struct SUTester: Translate {
    func localize(_ eng: String) -> String {
        return eng.localised(Lang.indonesian)
    }

    func stillCompatible() -> Bool {
        let ver = UIDevice.current.systemVersion
        let major = Int(ver.prefix(2)) ?? 0
        if major > 15 && major <= 17 {
            return true
        }
        return false
    }
}

extension String {
    func localised(_ language: Lang) -> String {
        let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
        let bundle: Bundle
        if let path = path {
            bundle = Bundle(path: path) ?? .main
        } else {
            bundle = .main
        }
        return localised(bundle: bundle)
    }

    private func localised(bundle: Bundle) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
