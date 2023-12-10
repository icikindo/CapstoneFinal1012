//
//  FavedEmpty.swift
//  Capstone3
//
//  Created by hastu on 03/11/23.
//

import SwiftUI

struct FavedEmpty: View {
    @State var animate = false
    @Environment(\.currentTab) var tab

    var body: some View {
        VStack {
            Text("Your favorite is currently empty")
                    .font(.title3)
                    .foregroundColor(Color.init(hex: "#c4c"))
                    .multilineTextAlignment(.leading)
                    .italic()
                    .padding(.top, 36)
            Spacer()
            Button {
                tab.wrappedValue = .catalog
            } label: {
                Text("Check Available Catalogs")
                    .foregroundColor(.white)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(animate ? Color.purple : Color.blue)
                    .cornerRadius(10)
            }.padding(.horizontal, animate ? 30 : 50)
                .shadow(color: animate ? Color.purple.opacity(0.8) : Color.blue.opacity(0.8),
                        radius: animate ? 30 : 10,
                        x: 0,
                        y: animate ? 50 : 30)
                .scaleEffect(animate ? 1.1 : 1.0)
                .offset(y: animate ? -5 : 0)
            Spacer()
            VStack {
                Text("from")
                    .font(.body)
                    .foregroundColor(Color.init(hex: "#666"))
                Text("`www.rawg.io`")
                    .font(.title2)
                    .foregroundColor(Color.init(hex: "08f"))
            }
            .padding(.bottom)
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .foregroundColor(.white)
        .onAppear {
            addAnimation()
        }
    }

    func addAnimation() {
        guard !animate else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(
                Animation
                    .easeInOut(duration: 2.0)
                    .repeatForever()
            ) {
                animate.toggle()
            }
        }
    }
}
