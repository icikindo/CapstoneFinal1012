//
//  GameHead.swift
//  CapstoneFinal
//
//  Created by hastu on 30/11/23.
//

import SwiftUI
import Core
import MFaved
import MGame

struct GameHead: View {
    @ObservedObject var presenter: GetItemPresenter<Any, CoreDomainModel,
       Interactor<Any, CoreDomainModel, GetGameRepository<GetRemoteGameSource, GetLocaleData, GameTransformer>>>
    let theGame: CoreDomainModel
    @AppStorage("language") var language = LocalizationService.shared.language
    @Environment(\.currentTab) var tab
    @State var isChecked = false
    @ObservedObject var user = UserDefaulte()

    var body: some View {
        VStack {
            content
        }
        .frame(width: UIScreen.main.bounds.width - 32)
        .background(Color.random.opacity(0.3))
        .cornerRadius(30)
    }
}

extension GameHead {
    var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            // let wasFaved = tab.wrappedValue == .faved || theGame.tstamp > 0
            let nameLength = theGame.name.count
            let nameSize = nameLength < 30 ? 18.0 : 14.0
            let nameTrack = nameLength < 20 ? 2.0 : 1.0
            HStack {
                Text(Image(systemName: "star.fill")).foregroundColor(.yellow) + Text(verbatim: " \(theGame.rating) [\(theGame.ratingsCount)] "
                    + "since".localized(language) + " \(theGame.released.formatDate())")
                    .font(.custom("Inconsolata", size: 14))
                Spacer()
                if presenter.inFaved {
                    Image(systemName: !isChecked ? "square" : "checkmark.square")
                        .resizable()
                        .scaledToFit()
                        .imageScale(.large)
                        .foregroundColor(.green)
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 8)
                        .onTapGesture {
                            let keyIndex = "\(theGame.id)|"
                            if !isChecked {
                                user.checked.append(keyIndex)
                            } else {
                                user.checked = user.checked.replacingOccurrences(of: keyIndex, with: "")
                            }
                            isChecked.toggle()
                        }
                } else {
                    Image(systemName: "square.dotted")
                        .resizable()
                        .scaledToFit()
                        .imageScale(.large)
                        .foregroundColor(Color.gray.opacity(0.8))
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 8)
                }
            }.onAppear {
                isChecked = user.checked.contains("\(theGame.id)")
            }
            Text(theGame.name)
                .font(.custom("Pointer", size: nameSize))
                .tracking(nameTrack)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 8)
            if theGame.screenshots.contains("http") {
                SlideShow(csv: theGame.screenshots)
            } else if !theGame.image.isEmpty {
                displayPicture
            } else {
                zonderDP
            }
            Spacer()
            HStack {
                Spacer()
                Text("Genre: \(theGame.genres)")
                    .font(.callout)
            }
        }.padding(
            EdgeInsets(
              top: 4,
              leading: 16,
              bottom: 8,
              trailing: 16
            )
        )
    }

    var displayPicture: some View {
        HStack {
            Spacer()
            CachedAsyncImage(url: URL(string: theGame.image)) { image in
                image.resizable()
                    .frame(minWidth: 285, minHeight: 190)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.yellow, lineWidth: 4))
            } placeholder: {
                ProgressView()
                    .tint(Color.init(hex: "707"))
                    .scaleEffect(5)
                    .frame(height: 190)
            }
            Spacer()
        }
    }

    var zonderDP: some View {
        HStack {
            Spacer()
            CachedAsyncImage(url: URL(string: EndPoints.Gets.zonk.url)) { image in
                image.resizable()
                    .frame(minWidth: 285, minHeight: 190)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 4))
            } placeholder: {
                ProgressView()
                    .tint(Color.init(hex: "707"))
                    .scaleEffect(5)
                    .frame(height: 190)
            }
            Spacer()
        }
    }
}
