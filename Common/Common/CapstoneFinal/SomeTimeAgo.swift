//
//  SomeTimeAgo.swift
//  Capstone3
//
//  Created by hastu on 04/11/23.
//

import Foundation
import SwiftUI

extension Double {
    func someTimeAgo() -> String {
        @AppStorage("language") var language = LocalizationService.shared.language
        let tstamp = self

        let myTimeInterval = TimeInterval(tstamp)
        let myTime = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        let myDate = myTime as Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyy HH:mm"

        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!

        if minuteAgo < myDate {
            let diff = Calendar.current.dateComponents([.second], from: myDate, to: Date()).second ?? 0
            if diff < 7 {
                return "now".localized(language)
            }
            return "\(diff) " + "seconds ago".localized(language)
        } else if hourAgo < myDate {
            let diff = Calendar.current.dateComponents([.minute], from: myDate, to: Date()).minute ?? 0
            return "\(diff) " + "minutes ago".localized(language)
        } else if dayAgo < myDate {
            let diff = Calendar.current.dateComponents([.hour], from: myDate, to: Date()).hour ?? 0
            return "\(diff) " + "hours ago".localized(language)
        } else if weekAgo < myDate {
            let diff = Calendar.current.dateComponents([.day], from: myDate, to: Date()).day ?? 0
            return "\(diff) " + "days ago".localized(language)
        }
        if language != userDefaultLanguage {
            dateFormatter.locale = Locale(identifier: language.rawValue)
        }
        return dateFormatter.string(from: myTime as Date)
    }

    func plainDateTime() -> String {
        @AppStorage("language") var language = LocalizationService.shared.language
        let tstamp = self
        let myTimeInterval = TimeInterval(tstamp)
        let myTime = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        let dateFormatter = DateFormatter()

        if language != userDefaultLanguage {
            dateFormatter.locale = Locale(identifier: language.rawValue)
        }
        dateFormatter.dateFormat = "EEE, d MMMM yyy H:mm"

        return dateFormatter.string(from: myTime as Date)
    }

}
