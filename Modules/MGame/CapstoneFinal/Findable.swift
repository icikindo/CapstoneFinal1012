//
//  Findable.swift
//  CapstoneFinal
//
//  Created by hastu on 02/12/23.
//

import SwiftUI

struct Findable: View {
    @Binding var findText: String
    @FocusState private var finderIsFocused: Bool
    @State var active = false

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Filter your favorite title", text: $findText, onEditingChanged: { editing in
                    withAnimation {
                        active = editing
                    }
                })
                .focused($finderIsFocused)
                .keyboardType(.asciiCapable)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                    .onTapGesture {
                        findText = ""
                        active = false
                        finderIsFocused = false
                    }
            }
            .padding(7)
            .background(Color(white: 0.9))
            .cornerRadius(10)

        }
        .font(.system(size: 14))
    }
}
