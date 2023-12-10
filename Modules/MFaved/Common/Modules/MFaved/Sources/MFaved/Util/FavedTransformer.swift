//
//  File.swift
//  
//
//  Created by hastu on 19/11/23.
//

import Core

public struct FavedTransformer: Mapper {
    public typealias Entity = [FavedModuleEntity]
    public typealias Domain = [FavedDomainModel]

    public init() {}

    public func transformEntityToDomain(entity: [FavedModuleEntity]) -> [FavedDomainModel] {
        return entity.map { ffd in
            return FavedDomainModel(
                id: ffd.id, name: ffd.name, rating: ffd.rating, ratingsCount: ffd.ratingsCount, released: ffd.released,
                image: ffd.image, imageAdditional: ffd.imageAdditional, desc: ffd.desc, web: ffd.web,
                slug: ffd.slug, genres: ffd.genres,
                screenshots: ffd.screenshots, note: ffd.note, tstamp: ffd.tstamp
            )
        }
    }

}
