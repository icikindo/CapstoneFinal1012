//
//  CatalogView.swift
//  CapstoneFinal
//
//  Created by hastu on 06/12/23.
//

import SwiftUI
import Core
import MCatalog
import MFaved
import MGame

struct CatalogView: View {
    @ObservedObject var presenter: GetListPresenter<Any, CatalogDomainModel,
        Interactor<Any, [CatalogDomainModel], GetCatalogRepository<GetRemoteSource, CatalogTransformer>>>
    @State private var alreadyFaveds: String = ""
    @State private var favedCount: Int = 0
    @State private var notIncludeFaved = false
    @AppStorage("language") var language = LocalizationService.shared.language

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                if presenter.isLoading {
                    loadingIndicator
                } else if presenter.isError {
                    errorIndicator
                } else if presenter.list.isEmpty {
                    notFoundIndicator
                } else {
                    content
                }
            }.onAppear {
                if self.presenter.list.isEmpty {
                    self.presenter.getList(request: nil)
                }
            }
            .navigationTitle("CATALOG".localized(language))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if presenter.searchWord.isEmpty {
                        Text(!notIncludeFaved ?
                             "\(Text("\(favedCount)") + Text(Image(systemName: "heart.fill")).foregroundColor(.red).font(.caption) + Text("\(presenter.available)"))" :
                                "\(presenter.available - favedCount)")
                        .font(.custom("Inconsolata", size: 16))
                        .foregroundColor(Color.init(hex: "339"))
                        .padding(.bottom, 4)
                    } else {
                        (Text("\(presenter.available) ") +  Text(Image(systemName: "exclamationmark.magnifyingglass")).foregroundColor(.red).font(.caption))
                            .font(.custom("Inconsolata", size: 16))
                            .foregroundColor(Color.init(hex: "339"))
                            .padding(.bottom, 4)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if favedCount > 0 {
                            notIncludeFaved.toggle()
                        }
                    } label: {
                        Image(favedCount == 0 ? "heartno" : notIncludeFaved ? "heartoff" : "hearton",
                              bundle: Bundle(identifier: "f43.app.Common"))
                    }
                }
            }
            .onChange(of: alreadyFaveds) { _ in
                favedCount = alreadyFaveds.components(separatedBy: "|").count-1
                if favedCount == 0 {
                    notIncludeFaved = false
                }
            }
        }
    }
}

extension CatalogView {
    var loadingIndicator: some View {
        VStack {
            SearchBar(presenter: presenter, text: $presenter.searchWord)
            Spacer()
            ProgressView()
                .tint(Color.init(hex: "707"))
                .scaleEffect(5)
                .padding(.bottom, 30)
            Text("Grabing data from rawg.io...")
                .font(.title2)
                .padding(.top, 30)
                .foregroundColor(Color.init(hex: "707"))
            Spacer()
        }
    }

    var errorIndicator: some View {
        VStack {
            Text("Error:\n\(presenter.errorMessage)")
                .foregroundColor(.red)
        }
    }

    var notFoundIndicator: some View {
        VStack {
            SearchBar(presenter: presenter, text: $presenter.searchWord)
            Text("Not found")
            Spacer()
        }
    }

    var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            SearchBar(presenter: presenter, text: $presenter.searchWord)
            ForEach(self.presenter.list, id: \.id) { catalog in
                let keyIndex = "\(catalog.id)|"
                if !notIncludeFaved || (notIncludeFaved && !alreadyFaveds.contains(keyIndex)) {
                    let gameUseCase: Interactor<
                        Any,
                        CoreDomainModel,
                        GetGameRepository<
                            GetRemoteGameSource,
                            GetLocaleData,
                            GameTransformer
                        >
                    > = Injection.init().provideGame(catalog.id)
                    var gamePresenter = GetItemPresenter(useCase: gameUseCase)
                    ZStack {
                        NavigationLink(destination: GameView(presenter: gamePresenter, gid: catalog.id, genres: catalog.genres, screenshots: catalog.screenshots)) {
                            CatalogRow(presenter: gamePresenter, catalog: catalog, alreadyFaveds: $alreadyFaveds)
                        }
                    }
                }
            }
        }
        .foregroundColor(.black)

    }
}
