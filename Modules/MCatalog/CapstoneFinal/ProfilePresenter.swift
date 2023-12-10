//
//  ProfilePresenter.swift
//  CapstoneFinal
//
//  Created by hastu on 27/11/23.
//

import SwiftUI

class ProfilePresenter: ObservableObject {
    private let profileUseCase: ProfileUseCase
    private let router = ProfileRouter()
    @EnvironmentObject var profilePresenter: ProfilePresenter

    init(profileUseCase: ProfileUseCase) {
        self.profileUseCase = profileUseCase
    }

    func linkDigger<Content: View>(icon: String, hint: String, @ViewBuilder content: () -> Content) -> some View {
        NavigationLink(destination: router.diggerView()) {
            ZStack {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 100, height: 30)
                    .cornerRadius(25)

                ( Text(Image(systemName: icon)) + Text("\u{00a0}\u{00a0}") + Text(" \(hint) " ))
                    .foregroundColor(.white)
            }
        }
    }
}
