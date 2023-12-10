//
//  File.swift
//  
//
//  Created by hastu on 20/11/23.
//

import Core
import Combine

public struct GetCatalogRepository<
    RemoteDataSource1: RemoteSource,
    Transformer: Rapper
>: Repository where
    RemoteDataSource1.Response == [Catalogue],
    RemoteDataSource1.Request == Any,
    Transformer.Response == [Catalogue],
    Transformer.Domain == [CatalogDomainModel] {

    public typealias Request = Any
    public typealias Response = [CatalogDomainModel]

    private let _remoteDataSource: RemoteDataSource1
    private let _rapper: Transformer

    public init(remoteDataSource: RemoteDataSource1, rapper: Transformer) {
        _remoteDataSource = remoteDataSource
        _rapper = rapper
    }

    public func execute(request: Any?) -> AnyPublisher<[CatalogDomainModel], Error> {
        return _remoteDataSource.execute(request: request)
            .map { _rapper.transformResponseToDomain(response: $0)}
            .eraseToAnyPublisher()
    }

    public func put(id: Int) -> AnyPublisher<[CatalogDomainModel], Error> {
        fatalError()
    }
    public func noted(id: Int) -> AnyPublisher<Noted, Error> {
        fatalError()
    }
    public func check(id: Int) -> AnyPublisher<Bool, Error> {
        fatalError()
    }

    public func del(id: Int) -> AnyPublisher<Bool, Error> {
        fatalError()
    }

    public func save(id: Int, note: String) -> AnyPublisher<Bool, Error> {
        fatalError()
    }
    public func fave(theGame: Core.CoreDomainModel) -> AnyPublisher<Bool, Error> {
        fatalError()
    }

}
