//
//  File.swift
//  
//
//  Created by hastu on 27/11/23.
//

import Foundation
import Combine
import Core
import MFaved

public struct GetGameRepository<
    RemoteDataSource: RemoteSource,
    FavedLocalSource: LocaleData,
    Transformer: Tapper
>: Repository where
    RemoteDataSource.Response == GameResponse,
    FavedLocalSource.Response == FavedModuleEntity,
    Transformer.Response == GameResponse,
    Transformer.Entity == FavedModuleEntity,
Transformer.Domain == CoreDomainModel {
        public typealias Request = Any
        public typealias Response = CoreDomainModel

        private let _remoteDataSource: RemoteDataSource
        private let _localeDataSource: FavedLocalSource
        private let _tapper: Transformer

        public init(
            remoteDataSource: RemoteDataSource,
            localeDataSource: FavedLocalSource,
            tapper: Transformer) {
                _remoteDataSource = remoteDataSource
                _localeDataSource = localeDataSource
                _tapper = tapper
            }

        public func execute(request: Any?) -> AnyPublisher<CoreDomainModel, Error> {
            return _remoteDataSource.execute(request: nil)
                .map { _tapper.transformResponseToDomain(response: $0)}
                .eraseToAnyPublisher()
        }
        public func put(id: Int) -> AnyPublisher<CoreDomainModel, Error> {
            _localeDataSource.put(id: id)
        }
        public func noted(id: Int) -> AnyPublisher<Noted, Error> {
            _localeDataSource.noted(id: id)
        }
        public func check(id: Int) -> AnyPublisher<Bool, Error> {
            _localeDataSource.check(id: id)
        }

        public func del(id: Int) -> AnyPublisher<Bool, Error> {
            _localeDataSource.del(id: id)
        }

        public func save(id: Int, note: String) -> AnyPublisher<Bool, Error> {
            _localeDataSource.save(id: id, note: note)
        }
        public func fave(theGame: CoreDomainModel) -> AnyPublisher<Bool, Error> {
            _localeDataSource.fave(theGame: theGame)
        }
}
