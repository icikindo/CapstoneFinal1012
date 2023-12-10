//
//  File.swift
//  
//
//  Created by hastu on 20/11/23.
//

public struct CatalogsResponse: Decodable {
    let catalogs: [CatalogResponse]
}

public struct CatalogResponse: Decodable {
    let id: Int
    let name: String
    let slug: String
    let released: String
    let rating: Float
    let ratingsCount: Int
    let image: String
    let imageAdditional: String
    let descriptionRaw: String
    let website: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case rating
        case ratingsCount = "ratings_count"
        case released
        case image = "background_image"
        case imageAdditional = "background_image_additional"
        case descriptionRaw
        case website
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = (try? container.decode(String.self, forKey: .name)) ?? "Unknown"
        slug = (try? container.decode(String.self, forKey: .slug)) ?? ""

        rating = try container.decode(Float.self, forKey: .rating)
        ratingsCount = try container.decode(Int.self, forKey: .ratingsCount)
        released = (try? container.decode(String.self, forKey: .released)) ?? "TBA"
        image = (try? container.decode(String.self, forKey: .image)) ?? ""
        imageAdditional = (try? container.decode(String.self, forKey: .imageAdditional)) ?? ""
        descriptionRaw = (try? container.decode(String.self, forKey: .descriptionRaw)) ?? ""
        website = (try? container.decode(String.self, forKey: .website)) ?? ""

    }
}
