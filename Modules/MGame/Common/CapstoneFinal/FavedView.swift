//
//  FavedView.swift
//  CapstoneFinal
//
//  Created by hastu on 06/12/23.
//

import SwiftUI
import Core
import MFaved
import MGame

var localContent = ""

struct FavedView: View {
    @ObservedObject var presenter: GetListPresenter<Any, FavedDomainModel,
        Interactor<Any, [FavedDomainModel], GetFavedRepository<GetLocaleData, FavedTransformer>>>
    @StateObject var autoComplete = AutocompleteObject()

    @Environment(\.currentTab) var tab
    @ObservedObject var user = UserDefaulte()
    @AppStorage("language") var language = LocalizationService.shared.language
    @State var justChecked = false
    @State var checkedCount: Int = 0

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                BackgroundView()
                if presenter.isLoading {
                    loadingIndicator
                } else if presenter.isError {
                    errorIndicator
                } else {
                    if presenter.list.isEmpty {
                        empty
                    } else {
                        content
                        FindBar(presenter: presenter, text: $presenter.searchWord, autoComplete: autoComplete)
                    }
                }
            }
            .onAppear {
                self.presenter.getList(request: nil)
                checkedCount = user.checked.components(separatedBy: "|").count-1
            }
            .onChange(of: user.checked.count) {_ in
                checkedCount = user.checked.components(separatedBy: "|").count-1
            }
            .navigationTitle("FAVED".localized(language))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text( (justChecked && checkedCount > 0) ? "\(checkedCount)/\(presenter.available)" : "\(presenter.available)" )
                        .frame(width: 24)
                        .foregroundColor(Color.init(hex: "339"))
                        .font(.custom("Inconsolata", size: 14))
                        .offset(x: -6, y: 0)
                }

                ToolbarItem(placement: .principal) {
                    Findable(findText: $presenter.searchWord)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                      if checkedCount > 0 {
                        justChecked = !justChecked
                      } else {
                          justChecked = false
                      }
                    } label: {
                        Image(checkedCount > 0 ? (justChecked ? "checkonly" : "checkmix") : "checkno",
                              bundle: Bundle(identifier: "f43.app.Common"))
                            .offset(x: 0, y: 4)
                    }
                }
            }
        }
    }
}

extension FavedView {
    var loadingIndicator: some View {
        VStack {
            Spacer()
            ProgressView()
                .tint(Color.init(hex: "707"))
                .scaleEffect(5)
                .padding(.bottom, 30)
            Text("Loading...")
                .font(.title2)
                .padding(.top, 30)
                .foregroundColor(Color.init(hex: "707"))
            Spacer()
        }
    }

    var errorIndicator: some View {
        VStack {
            Text("Error: \(presenter.errorMessage)")
                .foregroundColor(.red)
        }
    }

    var empty: some View {
        FavedEmpty()
    }

    var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            let keyword = presenter.searchWord
            ForEach(self.presenter.list, id: \.id) { faved in
                if !keyword.isEmpty && !faved.name.lowercased().contains(keyword.lowercased()) {
                } else {
                    let keyIndex = "\(faved.id)|"
                    let isChecked = user.checked.contains(keyIndex)
                    if (!justChecked || checkedCount == 0) || (justChecked && isChecked) {
                        let gameUseCase: Interactor<
                            Any,
                            CoreDomainModel,
                            GetGameRepository<
                                GetRemoteGameSource,
                                GetLocaleData,
                                GameTransformer
                            >
                        > = Injection.init().provideGame(faved.id)
                        let gamePresenter = GetItemPresenter(useCase: gameUseCase)
                        NavigationLink(destination: GameView(presenter: gamePresenter, gid: faved.id, genres: faved.genres, screenshots: faved.screenshots)) {
                            FavedRow(faved: faved, isChecked: isChecked)
                        }.task {
                            gamePresenter.inFaved = true
                            autoComplete.addParagraph(faved.name)
                            localContent.append(keyIndex)
                        }
                    }
                }
            }
            FavedAction(presenter: presenter)
        }
        .foregroundColor(.black)
        .onChange(of: presenter.searchWord) { keys in
            if !keys.isEmpty {
                autoComplete.lookUp(keys)
                autoComplete.isTapped = false
            }
        }
        .padding(.top, 10)
        .refreshable { }
    }
}
