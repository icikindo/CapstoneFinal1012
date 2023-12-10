//
//  GameView.swift
//  CapstoneFinal
//
//  Created by hastu on 27/11/23.
//

import SwiftUI
import Core
import MFaved
import MGame

struct GameView: View {
    @ObservedObject var presenter: GetItemPresenter<Any, CoreDomainModel,
       Interactor<Any, CoreDomainModel, GetGameRepository<GetRemoteGameSource, GetLocaleData, GameTransformer>>>
    let gid: Int
    let genres: String
    let screenshots: String
    @State var theGame: CoreDomainModel = CoreDomainModel.init(genres: "", screenshots: "")

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.currentTab) var tab

    var body: some View {
        let willOpenTab = "\(tab.wrappedValue)"
        NavigationStack {
            ZStack {
                BackgroundView()
                if presenter.isLoading {
                    loadingIndicator
                } else if presenter.isError {
                    errorIndicator
                } else {
                    content
                }
            }.onDisappear(perform: {
                if willOpenTab == "catalog" {
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension GameView {
    var loadingIndicator: some View {
        VStack {
            ProgressView()
                .tint(Color.init(hex: "707"))
                .scaleEffect(5)
                .padding(.bottom, 30)
            Text("Grabing data from rawg.io...")
                .font(.title2)
                .padding(.top, 30)
                .foregroundColor(Color.init(hex: "707"))
        }
    }

    var errorIndicator: some View {
        VStack {
            Text("Error:\n\(presenter.errorMessage)")
                .foregroundColor(.red)
        }
    }

    var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            GameHead(presenter: presenter, theGame: theGame)
                .padding(.top, 8)
            GameBody(presenter: presenter, theGame: theGame)
            GameFoot(presenter: presenter, theGame: theGame)

        }.onAppear {
            if presenter.item == nil {
                print("presenter.item = nil")
                let inFaved = presenter.inFaved
                if inFaved && gid != 0 {
                    presenter.putItem(gid)
                } else {
                    presenter.getItem(request: nil)
                }
            } else {
                theGame = presenter.item!
                guard theGame.id != 0 else {
                    return
                }
                theGame.genres = genres
                theGame.screenshots = screenshots
                presenter.noted(theGame.id)
            }
        }
    }

}
