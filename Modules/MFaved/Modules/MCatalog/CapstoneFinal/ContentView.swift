//
//  ContentView.swift
//  CapstoneFinal
//
//  Created by hastu on 05/12/23.
//

import SwiftUI
import UIKit
import Core
import MFaved
import MCatalog
import MGame
import GetiPhoneModel

struct ContentView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor

    enum Tab {
        case faved
        case catalog
        case profile
    }

    var body: some View {
        if !networkMonitor.isConnected {
            Disconnected()
        } else {
            Connected()
        }
    }

    struct Connected: View {
        @EnvironmentObject var profilePresenter: ProfilePresenter
        @EnvironmentObject var favedPresenter: GetListPresenter<Any, FavedDomainModel,
                    Interactor<Any, [FavedDomainModel], GetFavedRepository<GetLocaleData, FavedTransformer>>>
        @EnvironmentObject var catalogPresenter: GetListPresenter<Any, CatalogDomainModel,
                    Interactor<Any, [CatalogDomainModel], GetCatalogRepository<GetRemoteSource, CatalogTransformer>>>
        @ObservedObject var user = UserDefaulte()
        @AppStorage("language") var language = LocalizationService.shared.language
        @State private var selectedTab: Tab = .faved

        var body: some View {
            TabView(selection: $selectedTab) {
                Group {
                    FavedView(presenter: favedPresenter)
                        .tabItem {
                            TabItem(imageName: "heart", title: "FAVED".localized(language))
                        }
                        .tag(Tab.faved)
                        .environment(\.currentTab, $selectedTab)

                    CatalogView(presenter: catalogPresenter)
                        .tabItem {
                            TabItem(imageName: "book", title: "CATALOG".localized(language))
                        }
                        .tag(Tab.catalog)
                        .environment(\.currentTab, $selectedTab)

                    ProfileView(presenter: profilePresenter)
                        .tabItem {
                            TabItem(imageName: "person", title: "PROFILE".localized(language))
                        }
                        .tag(Tab.profile)
                        .environment(\.currentTab, $selectedTab)
                }
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Color.green.opacity(0.1), for: .tabBar)
            }.task {
                aboutDevice()
            }
        }

        func aboutDevice() {
            if user.theDevice == "?unrecognized?" {
                user.theOS = UIDevice.current.systemVersion
                GetiPhoneModel.model { model in
                    user.theDevice = model
                }
            }
        }
    }
}

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
