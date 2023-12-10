//
//  APICall.swift
//  Capstone3
//
//  Created by hastu on 02/11/23.
//

import Foundation

struct API {
    static let devilFruit = "f1626822d67042928d40d0aad6a0a968"
    static let baseURL = "https://api.rawg.io/api/games?key=\(devilFruit)"
}

protocol Endpoint {
    var url: String { get }
}

enum EndPoints {
    enum Gets: Endpoint {
        case catalog
        case search
        case game
        case zonk
        case slug

        public var url: String {
            switch self {
            case .catalog:
                let now = Date()
                let ago = Calendar.current.date(byAdding: .year, value: -1, to: now)
                let yearAgo = Calendar.current.component(.year, from: ago!)
                let yearNow = Calendar.current.component(.year, from: now)
                let month = Calendar.current.component(.month, from: now)
                let date = Calendar.current.component(.day, from: now)
                let datesQuery = String(format: "%d-%02d-%02d,%d-%02d-%02d", yearAgo, month, date, yearNow, month, date)
                return "\(API.baseURL)&page_size=40&ordering=-release&dates=\(datesQuery)"
            case .search: return "\(API.baseURL)&search_exact=true&ordering=-rating&search="
            case .game:
                return "\(API.baseURL)"
            case .slug: return "https://rawg.io/games/"
            case .zonk: return "https://media.rawg.io/media/resize/640/-/screenshots/4fe/4febb749cc8a48d492ad541144830ad7.jpg"
            }
        }
    }
}
