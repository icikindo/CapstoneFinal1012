//
//  UIApplication.swift
//  Capstone3
//
//  Created by hastu on 02/11/23.
//

import UIKit

extension UIApplication {
    static var release: String {
        if let bundel1 = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            return bundel1
        }
        return "x.x"
    }
    static var build: String {
        if let bundel2 = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            return bundel2
        }
        return "x"
    }
    static var version: String {
        return "\(release).\(build)"
    }
    static var name: String {
        if let bundel3 = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return bundel3
        }
        return "xxx"
    }
}
