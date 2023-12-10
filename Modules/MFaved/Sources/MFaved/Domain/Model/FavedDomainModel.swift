//
//  File.swift
//  
//
//  Created by hastu on 19/11/23.
//

public struct FavedDomainModel: Equatable, Identifiable {
    public var id: Int = 0
    public let name: String
    public let released: String
    public let rating: Float
    public let ratingsCount: Int
    public let image: String
    public let imageAdditional: String
    public let genres: String
    public let screenshots: String
    public let web: String
    public let slug: String
    public let desc: String
    public let note: String
    public let tstamp: Double

    init(id: Int, name: String, rating: Float, ratingsCount: Int, released: String,
         image: String, imageAdditional: String, desc: String, web: String, slug: String, genres: String,
         screenshots: String, note: String, tstamp: Double) {
            self.id = id
            self.name = name
            self.released = released
            self.rating = rating
            self.ratingsCount = ratingsCount
            self.image = image
            self.imageAdditional = imageAdditional
            self.genres = genres
            self.screenshots = screenshots
            self.web = web
            self.slug = slug
            self.desc = desc
            self.note = note
            self.tstamp = tstamp
        }
}
