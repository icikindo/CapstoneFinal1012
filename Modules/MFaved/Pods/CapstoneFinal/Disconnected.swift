//
//  Disconnected.swift
//  Capstone3
//
//  Created by hastu on 07/11/23.
//

import SwiftUI

struct Disconnected: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "exclamationmark.warninglight.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.yellow)
            Text("Disconnected")
                .font(.title)
                .foregroundColor(.red)
                .tracking(6)
                .bold()
                .padding()
            Text("No connection to internet world")
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
        }
        .background(.black)
    }
}
