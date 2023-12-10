//
//  CapstoneFinalApp.swift
//  CapstoneFinal
//
//  Created by hastu on 05/12/23.
//

import SwiftUI
import Core
import MFaved
import MCatalog
import MGame

let favedUseCase: Interactor<
    Any,
    [FavedDomainModel],
    GetFavedRepository<
        GetLocaleData,
        FavedTransformer
    >
> = Injection.init().provideFaveds()

let catalogUseCase: Interactor<
    Any,
    [CatalogDomainModel],
    GetCatalogRepository<
        GetRemoteSource,
        CatalogTransformer
    >
> = Injection.init().provideCatalogs()

@main
struct CapstoneFinalApp: App {
    init() {
        UIFont.loadFonts()
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.init(hex: "e60"))]
    }
    let profilePresenter = ProfilePresenter(profileUseCase: Injection.init().provideProfile())
    let favedPresenter = GetListPresenter(useCase: favedUseCase)
    let catalogPresenter = GetListPresenter(useCase: catalogUseCase)
    @StateObject var networkMonitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(profilePresenter)
            .environmentObject(favedPresenter)
            .environmentObject(catalogPresenter)
            .environmentObject(networkMonitor)
            .environment(\.locale, .init(identifier: "en"))
        }
    }
}

extension UIFont {
  private static func registerFont(withName name: String, fileExtension: String) {
    let frameworkBundle = Bundle(identifier: "f43.app.Common")!
    let pathForResourceString = frameworkBundle.path(forResource: name, ofType: fileExtension)!
    let fontData = NSData(contentsOfFile: pathForResourceString)
    let dataProvider = CGDataProvider(data: fontData!)
    let fontRef = CGFont(dataProvider!)
    var errorRef: Unmanaged<CFError>?
    if CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false {
      print("Error registering font")
    }
  }
  public static func loadFonts() {
    registerFont(withName: "Pointer-Bold", fileExtension: "otf")
  }
}
