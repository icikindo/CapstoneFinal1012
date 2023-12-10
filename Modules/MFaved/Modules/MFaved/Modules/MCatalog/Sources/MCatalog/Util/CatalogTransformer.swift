//
//  File.swift
//  
//
//  Created by hastu on 20/11/23.
//

import Core

public struct CatalogTransformer: Rapper {
    public typealias Response = [Catalogue]
    public typealias Domain = [CatalogDomainModel]
    public init() {}
    public func transformResponseToDomain(response: [Catalogue]) -> [CatalogDomainModel] {
        return response.map { result in
            let listOfGenres = result.unwrappedGenre.map {$0.name}.joined(separator: ",")
            let listOfScreenshots = result.unwarappedSchreenshots.map {$0.image}.joined(separator: ",")
            return CatalogDomainModel(
                id: result.id,
                name: result.name,
                rating: result.rating,
                ratingsCount: result.ratingsCount,
                image: result.image,
                genres: listOfGenres,
                screenshots: listOfScreenshots
            )
        }
    }
}
