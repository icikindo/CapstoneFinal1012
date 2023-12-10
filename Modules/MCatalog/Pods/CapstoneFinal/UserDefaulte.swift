//
//  UserDefaulte.swift
//  CapstoneFinal
//
//  Created by hastu on 04/12/23.
//

import SwiftUI

enum Language: String {
    case english = "en"
    case indonesian = "id"
    case unidentified = "ui"
}

let userDefaultName = "Hastu Wicaksono"
let userDefaultBrief = "Murid kursus Dicoding sejak September 2023"
let userDefaultLanguage = Language.english

class UserDefaulte: ObservableObject {
    @AppStorage("Device") var theDevice = "?unrecognized?"
    @AppStorage("OS") var theOS = "9.0"
    @AppStorage("OwnName") var ownName = ""
    @AppStorage("Brief") var brief = ""
    @AppStorage("Checked") var checked = ""
    @AppStorage("ProPic") var profilePicture = ""
}
