//
//  LanguageSetting.swift
//  CapstoneFinal
//
//  Created by hastu on 04/12/23.
//

import SwiftUI

struct LanguageSetting: View {
    @Binding var language: Language
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RadialGradient(colors: [.green.opacity(0.3), .blue.opacity(0.5)],
                               center: .bottomTrailing,
                               startRadius: 0, endRadius: 300)
                .ignoresSafeArea(edges: .top)
                .frame(height: 0)
            HStack {
                Spacer()
                (Text("settings_language".localized(language) + " ") + Text(Image(systemName: "chevron.right")))
                    .font(.system(size: 18))
                    .foregroundColor(.blue)
                Menu {
                    Button {
                        language = .english
                    } label: {
                        Text("English Language")
                    }
                    Button {
                        language = .indonesian
                    } label: {
                        Text("Bahasa Indonesia")
                    }
                } label: {
                    Text(language.rawValue.uppercased())
                        .frame(width: 30, height: 30)
                        .font(.system(size: 16))
                        .background(Color.yellow)
                        .clipShape(Circle())
                        .bold()
                        .offset(x: 0, y: 2)
                        .foregroundColor(.black)
                }
            }
            .padding(.trailing)
            Text("settings_language_footer".localized(language))
                .foregroundColor(Color.black.opacity(0.8))
                .font(.headline)
                .padding(.leading)
            Spacer()
        }
        .cornerRadius(10)
    }
}
