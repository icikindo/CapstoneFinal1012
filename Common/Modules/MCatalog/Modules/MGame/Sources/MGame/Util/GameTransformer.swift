//
//  File.swift
//  
//
//  Created by hastu on 20/11/23.
//

import Core
import MFaved

public struct GameTransformer: Tapper {
    public typealias Response = GameResponse
    public typealias Entity = FavedModuleEntity
    public typealias Domain = CoreDomainModel

    public init() {}

    public func transformResponseToDomain(response: Response) -> CoreDomainModel {
        let listOfGenres = ""
        let listOfScreenshots = ""
        return CoreDomainModel(
            id: response.id,
            name: response.name,
            rating: response.rating,
            ratingsCount: response.ratingsCount,
            released: response.released,
            image: response.image,
            imageAdditional: response.imageAdditional,
            desc: response.descriptionRaw,
            web: response.website,
            slug: response.slug,
            genres: listOfGenres,
            screenshots: listOfScreenshots,
            note: "",
            tstamp: 0)
    }

}
