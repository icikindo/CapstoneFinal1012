//
//  CurrentTabKey.swift
//  Capstone3
//
//  Created by hastu on 01/11/23.
//

import SwiftUI

struct CurrentTabKey: EnvironmentKey {
    static var defaultValue: Binding<ContentView.Tab> = .constant(.faved)
}

extension EnvironmentValues {
    var currentTab: Binding<ContentView.Tab> {
        get { self[CurrentTabKey.self] }
        set { self[CurrentTabKey.self] = newValue }
    }
}
