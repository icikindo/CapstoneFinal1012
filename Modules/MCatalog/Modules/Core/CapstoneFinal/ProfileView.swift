//
//  ProfileView.swift
//  CapstoneFinal
//
//  Created by hastu on 06/12/23.
//

import SwiftUI
// import UIKit

struct ProfileView: View {
    @ObservedObject var presenter: ProfilePresenter

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var user = UserDefaulte()
    @AppStorage("language") var language = LocalizationService.shared.language

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                content
            }
            .navigationTitle("PROFILE".localized(language))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension ProfileView {
    var content: some View {
        VStack {
            let imgWidth = 320.0
            let imgHeight = 4.2 * imgWidth / 2.8
            let displayName = user.ownName.isEmpty ? userDefaultName : user.ownName
            let displayBrief = user.brief.isEmpty ? userDefaultBrief : user.brief

            (Text("**\(UIApplication.name.unCamelCased())** "  + "versi".localized(language) + " \(UIApplication.version)"))
                .font(.custom("Inconsolata", size: 22))
            (Text("on".localized(language) + " \(user.theDevice) " +  "with".localized(language) + " iOS \(user.theOS)"))
                .font(.custom("Inconsolata", size: 16))
            Text("belong".localized(language))
                .padding(.top, 12)
            if !user.profilePicture.isEmpty {
                if let profilePicture = retrieveImage(from: user.profilePicture) {
                    Image(uiImage: profilePicture)
                        .resizable()
                        .scaledToFit()
                        .shadow(color: .gray, radius: 4, x: 10, y: 10)
                        .frame(width: imgWidth, height: imgHeight)
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black.opacity(0.5), style: StrokeStyle(lineWidth: 3, dash: [5]))
                        )
                        .animation(Animation.easeInOut(duration: 2.3), value: UUID())
                } else {
                    let noPicture = Image("canvas", bundle: Bundle(identifier: "f43.app.Common")).asUIImage()
                    Image(uiImage: noPicture)
                        .resizable()
                        .scaledToFit()
                        .shadow(color: .gray, radius: 4, x: 10, y: 10)
                        .frame(width: imgWidth, height: imgHeight)
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black.opacity(0.5), style: StrokeStyle(lineWidth: 3, dash: [5]))
                        )
                        .animation(Animation.easeInOut(duration: 2.3), value: UUID())
                }
            } else {
                let profilePicture = Image("pasfoto", bundle: Bundle(identifier: "f43.app.Common")).asUIImage()
                Image(uiImage: profilePicture)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .gray, radius: 4, x: 10, y: 10)
                    .frame(width: imgWidth, height: imgHeight)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black.opacity(0.5), style: StrokeStyle(lineWidth: 3, dash: [5]))
                    )
                    .animation(Animation.easeInOut(duration: 2.3), value: UUID())
            }

            HStack {
                Spacer()
                self.presenter.linkDigger(icon: "pencil", hint: "edit".localized(language)) {}
            }
            .padding(.trailing, 12)
            Text(displayName)
                .font(.headline).tracking(2)
                .scaleEffect(1.45)
                .padding(.bottom, 4)
            Text(displayBrief)
                .font(.system(size: 16)).italic()
                .padding(.bottom, 12)
        }
    }
}
