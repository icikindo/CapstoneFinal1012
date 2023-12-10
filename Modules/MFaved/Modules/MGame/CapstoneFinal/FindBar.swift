//
//  FindBar.swift
//  Capstone3
//
//  Created by hastu on 05/11/23.
//

import SwiftUI
import Core
import MFaved

struct FindBar: View {
    @ObservedObject var presenter: GetListPresenter<Any, FavedDomainModel,
        Interactor<Any, [FavedDomainModel], GetFavedRepository<GetLocaleData, FavedTransformer>>>
    @Binding var text: String
    @ObservedObject var autoComplete: AutocompleteObject
    @State var suggestions = ["jambu", "mete", "jeruk", "pisang"]

    @State private var textHeight: Double = 20
    let listRowPadding: Double = 5 // This is a guess
    let listRowMinHeight: Double = 45 // This is a guess
    var listRowHeight: Double {
          max(listRowMinHeight, textHeight + 2 * listRowPadding)
    }
    var body: some View {
        ZStack {
            List(autoComplete.suggestions, id: \.self) { suggestion in
                Text(suggestion)
                    .font(.system(size: 14))
                    .onTapGesture {
                        autoComplete.isTapped = true
                        presenter.searchWord = suggestion
                    }
                    .listRowBackground(Color(hex: "efe").opacity(0.1))
                    .padding(.leading, 8)
                    .padding(.trailing, 16)
                    .padding(.vertical, 4)
                    .foregroundColor(Color(hex: "234"))
                    .background(Color(hex: "eee"))
                    .frame(maxWidth: .infinity, maxHeight: textHeight, alignment: .leading)
                    .contentShape(Rectangle())
            }
            .frame(height: CGFloat(1 + autoComplete.suggestions.count) * CGFloat(self.listRowHeight))
            .scrollContentBackground(.hidden)
            .isHidden($autoComplete.suggestions.isEmpty || autoComplete.isTapped, remove: $autoComplete.suggestions.isEmpty)
            .offset(x: 30, y: -48)
        }
    }
}
