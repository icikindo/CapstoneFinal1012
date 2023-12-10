//
//  BackgroundView.swift
//  Capstone3
//
//  Created by hastu on 03/11/23.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Color.green
            .opacity(0.1)
            .ignoresSafeArea()
        // NavigationView Background
        VStack {
            RadialGradient(colors: [.green.opacity(0.3), .blue.opacity(0.5)],
                           center: .bottomTrailing,
                           startRadius: 0, endRadius: 300)
            .ignoresSafeArea(edges: .top)
            .frame(height: 0)
            Spacer()
        }
    }
}
