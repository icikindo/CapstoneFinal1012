//
//  Injection.swift
//  CapstoneFinal
//
//  Created by hastu on 06/12/23.
//

import Foundation
import RealmSwift
import Core
import MFaved
import MCatalog
import MGame

final class Injection: NSObject {
    private let realm = try? Realm()
    func provideFaveds<U: UseCase>() -> U where U.Request == Any, U.Response == [FavedDomainModel] {
        let locale = GetLocaleData(realm: realm!)
        let mapper = FavedTransformer()
        let repository = GetFavedRepository(localeDataSource: locale, mapper: mapper)
        return Interactor(repository: repository) as! U
    }

    func provideCatalogs<U: UseCase>(_ words: String = "") -> U where U.Request == Any, U.Response == [CatalogDomainModel] {
        /*
        var urlString = EndPoints.Gets.catalog.url
        if !words.isEmpty {
            let keywords =  words.components(separatedBy: .whitespacesAndNewlines).joined(separator: "%20")
            urlString = "\(EndPoints.Gets.search.url)\(keywords)"
        }
        */
        let remote = GetRemoteSource(endpoint: EndPoints.Gets.catalog.url, search: EndPoints.Gets.search.url)
        let rapper = CatalogTransformer()
        let repository = GetCatalogRepository(remoteDataSource: remote, rapper: rapper)
        return Interactor(repository: repository) as! U
    }

    func provideGame<U: UseCase>(_ gameId: Int) -> U where U.Request == Any, U.Response == CoreDomainModel {
        let locale = GetLocaleData(realm: realm!)
        let remote = GetRemoteGameSource(endpoint: EndPoints.Gets.game.url.replacingOccurrences(of: "/games", with: "/games/\(gameId)"))
        let tapper = GameTransformer()
        let repository = GetGameRepository(remoteDataSource: remote, localeDataSource: locale, tapper: tapper)
        return Interactor(repository: repository) as! U
    }

    func provideProfile() -> ProfileUseCase {
        return ProfileInteractor()
    }

    func provideEditor() -> EditorUseCase {
        return EditorInteractor()
    }
}
