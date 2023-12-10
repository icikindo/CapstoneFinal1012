//
//  File.swift
//  
//
//  Created by hastu on 20/11/23.
//

import Foundation

public struct Catalogues: Decodable {
    let count: Int
    let all: [Catalogue]

    enum CodingKeys: String, CodingKey {
        case count
        case all = "results"
      }
}

public struct Catalogue: Decodable {
    let id: Int
    let name: String
    let rating: Float
    let ratingsCount: Int
    let image: String
    var genres: [Genre]?
    var unwrappedGenre: [Genre] {
        genres ?? [Genre(name: "")]
    }
    var screenshots: [Screenshot]?
    var unwarappedSchreenshots: [Screenshot] {
        screenshots ?? [Screenshot(image: "")]
    }

  private enum CodingKeys: String, CodingKey {
      case id
      case name
      case rating
      case ratingsCount = "ratings_count"
      case image = "background_image"
      case genres
      case screenshots = "short_screenshots"
  }
}

struct Genre: Codable, Identifiable {
    let id = UUID()
    var name: String

    init(name: String) { self.name = name }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decodeIfPresent(String.self, forKey: .name)
        self.name = name ?? "-"
    }
}

struct Screenshot: Codable, Identifiable {
    let id = UUID()
    var image: String

    init(image: String) { self.image = image }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let image = try container.decodeIfPresent(String.self, forKey: .image)
        self.image = image ?? ""
    }
}
