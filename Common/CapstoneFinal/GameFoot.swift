//
//  GameFoot.swift
//  CapstoneFinal
//
//  Created by hastu on 01/12/23.
//

import SwiftUI
import Core
import MFaved
import MGame

struct GameFoot: View {
    @ObservedObject var presenter: GetItemPresenter<Any, CoreDomainModel,
       Interactor<Any, CoreDomainModel, GetGameRepository<GetRemoteGameSource, GetLocaleData, GameTransformer>>>
    let theGame: CoreDomainModel
    @AppStorage("language") var language = LocalizationService.shared.language
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.currentTab) var tab
    @ObservedObject var user = UserDefaulte()

    var body: some View {
        VStack {
            content
        }
        .frame(width: UIScreen.main.bounds.width - 32)
    }

    func delItem() {
        let keyIndex = "\(theGame.id)|"
        user.checked = user.checked.replacingOccurrences(of: keyIndex, with: "")
        presenter.del(theGame.id)
        if tab.wrappedValue == .faved {
            dismiss()
        } else {
            tab.wrappedValue = .faved
        }
    }

    func faveItem() {
        presenter.fave(theGame: theGame)
        if presenter.wasNoted {
            presenter.save(id: theGame.id)
        }
        presenter.theNote = ""
        if tab.wrappedValue == .faved {
            dismiss()
        } else {
            dismiss()
            tab.wrappedValue = .faved
        }
    }

    internal func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }

}

extension GameFoot {
    var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                if presenter.inFaved || presenter.timeStamp != 0 {
                    VStack {
                        (Text(Image(systemName: "heart.fill")).foregroundColor(.red)
                            + Text(" " + "Last update".localized(language)
                                + ": \(presenter.timeStamp.someTimeAgo())") )
                            .font(.custom("Inconsolata", size: 14))
                            .padding(8)
                        Button(action: {
                            delItem()
                        }, label: {
                            (Text(Image(systemName: "heart.slash")) + Text(" " + "Unfave".localized(language)))
                                .foregroundColor(.purple)
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .frame(minWidth: 0, maxWidth: 120)
                                .frame(height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.init(hex: "ede"))
                                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                                )
                                .buttonStyle(.borderedProminent)
                        })
                    }
                } else {
                    VStack {
                        (Text(Image(systemName: "heart.slash")).foregroundColor(.brown) + Text(" " +
                         "This game is not faved yet".localized(language)).foregroundColor(.purple))
                            .font(.custom("Inconsolata", size: 14))
                            .padding(8)
                        Button(action: {
                            faveItem()
                        }, label: {
                            (Text(Image(systemName: "heart.fill")) + Text(" " + "Fave It".localized(language)))
                                .foregroundColor(.red)
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .frame(minWidth: 0, maxWidth: 120)
                                .frame(height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.init(hex: "edd"))
                                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                                )
                                .buttonStyle(.borderedProminent)
                        })
                    }
                }
                Spacer()
            }
            HStack {
                Spacer()
                Button(action: {
                    presenter.check(theGame.id)
                }, label: {
                    Text("©")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                })
                Spacer()
            }
            .padding()
        }
    }
}
