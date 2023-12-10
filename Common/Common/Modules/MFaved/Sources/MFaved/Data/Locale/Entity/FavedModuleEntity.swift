//
//  File.swift
//  
//
//  Created by hastu on 19/11/23.
//

import Foundation
import RealmSwift

public class FavedModuleEntity: Object {
    @objc dynamic var tstamp: Double = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var name = ""
    @objc dynamic var rating: Float = 0
    @objc dynamic var ratingsCount: Int = 0
    @objc dynamic var image = ""
    @objc dynamic var imageAdditional = ""
    @objc dynamic var released = ""
    @objc dynamic var desc = ""
    @objc dynamic var web = ""
    @objc dynamic var genres = ""
    @objc dynamic var screenshots = ""
    @objc dynamic var slug = ""
    @objc dynamic var note = ""

    public override init() {}

    public override static func primaryKey() -> String {
        return "id"
    }
}
