//
//  File.swift
//  
//
//  Created by hastu on 20/11/23.
//

public struct CatalogDomainModel: Equatable, Identifiable {
    public let id: Int
    public let name: String
    public let rating: Float
    public let ratingsCount: Int
    public let image: String
    public let genres: String
    public let screenshots: String
}

public struct CatalogsModel: Equatable {
    public var data: [CatalogDomainModel]
}
