//
//  SearchBar.swift
//  Capstone3
//
//  Created by hastu on 03/11/23.
//

import SwiftUI
import Core
import MCatalog

struct SearchBar: View {
    @ObservedObject var presenter: GetListPresenter<Any, CatalogDomainModel,
        Interactor<Any, [CatalogDomainModel], GetCatalogRepository<GetRemoteSource, CatalogTransformer>>>
    @Binding var text: String
    @State private var isEditing = false
    @State private var lastWords = ""
    @State private var initWords = ""
    @State private var timer: Timer?
    @State var stillSame: Int = 0

    var body: some View {
        HStack {
            TextField("What games are you looking forward to?", text: $text, onEditingChanged: {_ in
                if !isEditing {
                    self.initWords = text
                    reactiveTimer()
                }
                isEditing = true
            })
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(white: 0.8))
            .foregroundColor(.black)
            .cornerRadius(8)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .overlay(
                HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.indigo)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        if isEditing {
                            Button {
                                text = ""
                                isEditing = false
                                Task {
                                    presenter.getSearch()
                                }
                            } label: {
                                Image(systemName: "multiply.circle")
                                    .foregroundColor(.indigo)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 8)
                .onSubmit {
                    Task {
                        isEditing = false
                        presenter.getSearch()
                    }
                }
                .submitLabel(.search)

            if isEditing {
                Button {
                    isEditing = false
                    text  = initWords
                } label: {
                    withAnimation {
                        Text("Cancel")
                            .padding(.trailing, 10)
                            .transition(.move(edge: .trailing))
                            .font(.body)
                    }
                }
            }
        }
        .animation(Animation.easeInOut(duration: 0.4), value: isEditing)
    }

    internal func reactiveTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if !isEditing {
                stillSame = 0
                timer?.invalidate()
            } else if self.text == self.initWords {
                stillSame = 0
            } else if self.lastWords != self.text {
                self.lastWords = self.text
                stillSame = 0
            } else if stillSame > 2 {
                timer?.invalidate()
                stillSame = 0
                isEditing = false
                presenter.getSearch()
            } else {
                stillSame += 1
            }

        }
    }
}
