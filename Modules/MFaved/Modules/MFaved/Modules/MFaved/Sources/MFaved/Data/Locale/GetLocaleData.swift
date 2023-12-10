//
//  File.swift
//  
//
//  Created by hastu on 19/11/23.
//

import Foundation
import Combine
import Core
import RealmSwift

public struct GetLocaleData: LocaleData {
    public typealias Request = Any
    public typealias Response = FavedModuleEntity

    private let _realm: Realm

    public init(realm: Realm) {
        _realm = realm
    }

    public func list(request: Any?) -> AnyPublisher<[FavedModuleEntity], Error> {
        return Future<[FavedModuleEntity], Error> { completion in
            let faveds: Results<FavedModuleEntity> = {
              _realm.objects(FavedModuleEntity.self)
                .sorted(byKeyPath: "tstamp", ascending: false)
            }()
            completion(.success(faveds.toArray(ofType: FavedModuleEntity.self)))

        }.eraseToAnyPublisher()
    }

   public func put(id: Int) -> AnyPublisher<CoreDomainModel, Error> {
       return Future<CoreDomainModel, Error> { completion in
           do {
               try _realm.write {
                   let ffd = _realm.object(ofType: FavedModuleEntity.self, forPrimaryKey: id)
                   let wasFaved = ffd != nil
                   if wasFaved {
                       let cdm = CoreDomainModel(id: ffd?.id ?? 0, name: ffd?.name ?? "Unknown",
                        rating: ffd?.rating ?? 0, ratingsCount: ffd?.ratingsCount ?? 0,
                            released: ffd?.released ?? "",
                            image: ffd?.image ?? "", imageAdditional: ffd?.imageAdditional ?? "",
                            desc: ffd?.desc ?? "", web: ffd?.web ?? "", slug: ffd?.slug ?? "",
                            genres: ffd?.genres ?? "", screenshots: ffd?.screenshots ?? "",
                            note: ffd?.note ?? "", tstamp: ffd?.tstamp ?? 0)
                       completion(.success(cdm))
                   } else {
                       completion(.failure(DatabaseError.requestFailed))
                   }
               }
           } catch {
               completion(.failure(DatabaseError.invalidInstance))
           }
       }.eraseToAnyPublisher()
   }

    public func noted(id: Int) -> AnyPublisher<Noted, Error> {
        return Future<Noted, Error> { completion in
            do {
                try _realm.write {
                    let ffd = _realm.object(ofType: FavedModuleEntity.self, forPrimaryKey: id)
                    let theTime = ffd?.tstamp ?? 0.0
                    let theNote = ffd?.note ?? ""
                    let ret = Noted.init(tstamp: theTime, note: theNote)
                    completion(.success(ret))
                }
            } catch {
                completion(.failure(DatabaseError.requestFailed))
            }
        }.eraseToAnyPublisher()
    }

   public func check(id: Int) -> AnyPublisher<Bool, Error> {
       return Future<Bool, Error> { completion in
           do {
               try _realm.write {
                   let ffd = _realm.object(ofType: FavedModuleEntity.self, forPrimaryKey: id)
                   let wasFaved = ffd != nil
                   completion(.success(wasFaved))
               }
           } catch {
               completion(.failure(DatabaseError.requestFailed))
           }
       }.eraseToAnyPublisher()
   }

    public func del(id: Int) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            do {
                let ffd = _realm.object(ofType: FavedModuleEntity.self, forPrimaryKey: id)
                try _realm.write {
                    _realm.delete(ffd!)
                }
                completion(.success(true))
            } catch {
                completion(.failure(DatabaseError.requestFailed))
            }
        }.eraseToAnyPublisher()
    }

    public func save(id: Int, note: String) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            do {
                try _realm.write {
                    if let ffd = _realm.object(ofType: FavedModuleEntity.self, forPrimaryKey: id) {
                        ffd.note = note
                        ffd.tstamp = NSDate().timeIntervalSince1970
                        _realm.add(ffd, update: .modified)
                    } else {
                        completion(.failure(DatabaseError.requestFailed))
                    }
                }
                completion(.success(true))
            } catch {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }

    public func fave(theGame: CoreDomainModel) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            do {
                try _realm.write {
                    let ffd = FavedModuleEntity()
                    let tstamp = NSDate().timeIntervalSince1970
                    ffd.tstamp = tstamp
                    ffd.id = theGame.id
                    ffd.name = theGame.name
                    ffd.released = theGame.released
                    ffd.rating = theGame.rating
                    ffd.ratingsCount = theGame.ratingsCount
                    ffd.image = theGame.image
                    ffd.imageAdditional = theGame.imageAdditional
                    ffd.genres = theGame.genres
                    ffd.screenshots = theGame.screenshots
                    ffd.web = theGame.web
                    ffd.slug = theGame.slug
                    ffd.desc = theGame.desc
                    ffd.note = theGame.note
                    _realm.add(ffd)
                }
                completion(.success(true))
            } catch {
                completion(.failure(DatabaseError.requestFailed))
            }

        }.eraseToAnyPublisher()
    }

    public func unFave(id: Int) -> AnyPublisher<Bool, Error> {
        fatalError()
    }
}
