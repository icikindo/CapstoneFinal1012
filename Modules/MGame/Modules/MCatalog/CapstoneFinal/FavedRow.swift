//
//  FavedRow.swift
//  CapstoneFinal
//
//  Created by hastu on 29/11/23.
//

import SwiftUI
import MFaved

struct FavedRow: View {
    var faved: FavedDomainModel
    var isChecked = false
    @ObservedObject var user = UserDefaulte()
    @AppStorage("language") var language = LocalizationService.shared.language
    @State var opasiti: CGFloat = 0.0

    var repeatingAnimation: Animation {
        Animation
            .easeInOut(duration: 3.5)
            .delay(1.0)
            .repeatForever()
    }

    var body: some View {
        VStack {
            content
        }
        .frame(width: UIScreen.main.bounds.width - 32)
        .background(Color.random.opacity(0.3))
        .cornerRadius(30)
        .padding(.top, 4)
    }

}

extension FavedRow {
    var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            let nameLength = faved.name.count
            let nameSize = nameLength < 30 ? 18.0 : 14.0
            let nameTrack = nameLength < 20 ? 2.0 : 1.0
            HStack {
                (Text(Image(systemName: "heart.fill")).foregroundColor(.red) + Text(" \(faved.tstamp.someTimeAgo())"))
                    .font(.custom("Inconsolata", size: 14))
                Spacer()
                Image(systemName: !isChecked ? "square" : "checkmark.square")
                    .resizable()
                    .scaledToFit()
                    .imageScale(.large)
                    .foregroundColor(.green)
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 8)
                    .onTapGesture {
                        let keyIndex = "\(faved.id)|"
                        if !isChecked {
                            user.checked.append(keyIndex)
                        } else {
                            user.checked = user.checked.replacingOccurrences(of: keyIndex, with: "")
                        }
                    }
            }

            Text(faved.name)
                .font(.custom("Pointer", size: nameSize))
                .tracking(nameTrack)
                .lineLimit(2)
                 .multilineTextAlignment(.leading)
                .padding(.bottom, 8)
            if !faved.imageAdditional.isEmpty && !faved.image.isEmpty {
                doubleExposure
            } else if !faved.image.isEmpty {
                displayPicture
            } else {
                zonderDP
            }
            HStack {
                Spacer()
                (Text(Image(systemName: "star.fill")).foregroundColor(.yellow) + Text(verbatim: " \(faved.rating) [\(faved.ratingsCount)] / \(faved.released.formatDate())"))
                    .font(.custom("Inconsolata", size: 16))
            }
            .padding(.top, 4)

            VStack {
                Text(faved.note.isEmpty ? "No personal note for".localized(language) + " \(faved.name)" : faved.note)
                    .foregroundColor(faved.note.isEmpty ? Color.gray.opacity(0.5) : Color.init(hex: "00b"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .font(.system(size: 14))
                    .multilineTextAlignment(.leading)
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color.init(hex: "ff0"), Color.init(hex: "cff")]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(20)
            .padding(.top, 8)
      }.padding( // Vstack
        EdgeInsets(
          top: 0,
          leading: 16,
          bottom: 8,
          trailing: 16
        )
      )
    }

    var doubleExposure: some View {
        HStack {
            Spacer()
            CachedAsyncImage(url: URL(string: faved.imageAdditional)) { image in
                image.resizable()
                    .frame(minWidth: 300, minHeight: 200)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.yellow, lineWidth: 4))
                    .opacity(opasiti)
                    .onAppear {
                        withAnimation(self.repeatingAnimation) {
                            opasiti = 1.0
                        }
                    }
                    .onDisappear {
                        opasiti = 0.0
                    }
            } placeholder: {
                ProgressView()
                    .tint(Color.init(hex: "707"))
                    .scaleEffect(5)
                    .frame(height: 200)
            }
            .background(
                CachedAsyncImage(url: URL(string: faved.image)) { bgImage in
                    bgImage.resizable()
                        .frame(minWidth: 300, minHeight: 200)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.yellow, lineWidth: 4))
                } placeholder: {
                    ProgressView()
                        .tint(Color.init(hex: "707"))
                        .scaleEffect(5)
                        .frame(height: 200)
                }
            )
            Spacer()
        }
    }

    var displayPicture: some View {
        HStack {
            Spacer()
            CachedAsyncImage(url: URL(string: faved.image)) { image in
                image.resizable()
                    .frame(minWidth: 300, minHeight: 200)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.yellow, lineWidth: 4))
            } placeholder: {
                ProgressView()
                    .tint(Color.init(hex: "707"))
                    .scaleEffect(5)
                    .frame(height: 200)
            }
            Spacer()
        }
    }

    var zonderDP: some View {
        HStack {
            Spacer()
            CachedAsyncImage(url: URL(string: EndPoints.Gets.zonk.url)) { image in
                image.resizable()
                    .frame(minWidth: 300, minHeight: 200)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 4))
            } placeholder: {
                ProgressView()
                    .tint(Color.init(hex: "707"))
                    .scaleEffect(5)
                    .frame(height: 200)
            }
            Spacer()
        }
    }
}
