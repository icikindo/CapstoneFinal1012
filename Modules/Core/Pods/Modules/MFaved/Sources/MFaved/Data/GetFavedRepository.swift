//
//  File.swift
//  
//
//  Created by hastu on 19/11/23.
//

import Core
import Combine

public struct GetFavedRepository<
    FavedLocaleSource: LocaleData,
    Transformer: Mapper
>: Repository where
    FavedLocaleSource.Response == FavedModuleEntity,
    Transformer.Entity == [FavedModuleEntity],
Transformer.Domain == [FavedDomainModel] {
    public typealias Request = Any
    public typealias Response = [FavedDomainModel]
    private let _localeDataSource: FavedLocaleSource
    private let _mapper: Transformer

    public init(
            localeDataSource: FavedLocaleSource,
            mapper: Transformer) {
            _localeDataSource = localeDataSource
            _mapper = mapper
        }

        public func execute(request: Any?) -> AnyPublisher<[FavedDomainModel], Error> {
            return _localeDataSource.list(request: nil)
              .flatMap { _ -> AnyPublisher<[FavedDomainModel], Error> in
                  return _localeDataSource.list(request: nil)
                    .map { _mapper.transformEntityToDomain(entity: $0) }
                    .eraseToAnyPublisher()
              }.eraseToAnyPublisher()
        }

        public func put(id: Int) -> AnyPublisher<[FavedDomainModel], Error> {
            fatalError()
        }
        public func noted(id: Int) -> AnyPublisher<Noted, Error> {
            fatalError()
        }
        public func check(id: Int) -> AnyPublisher<Bool, Error> {
            fatalError()
        }
        public func add(id: Int, name: String) -> AnyPublisher<Bool, Error> {
            fatalError()
        }
        public func del(id: Int) -> AnyPublisher<Bool, Error> {
            fatalError()
        }
        public func save(id: Int, note: String) -> AnyPublisher<Bool, Error> {
            fatalError()
        }
        public func fave(theGame: CoreDomainModel) -> AnyPublisher<Bool, Error> {
            fatalError()
        }
}
