//
//  SlideShow.swift
//  Capstone3
//
//  Created by hastu on 06/11/23.
//

import SwiftUI

struct SlideShow: View {
    let csv: String
    let zonk = EndPoints.Gets.zonk.url

    var body: some View {
        let urlList = csv.components(separatedBy: ",")
        ZStack {
            ForEach(urlList, id: \.self) { urlString in
                if urlString != urlList[0] {
                    cachedImage(urlString: urlString)
                        .opacity(0)
                }
            }
            TabView {
                ForEach(urlList, id: \.self) { urlString in
                    if urlString != urlList[0] {
                        cachedImage(urlString: urlString)
                            .padding(2)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        }
    }
}

extension SlideShow {
    // For displaying an async image from given string.
    private func cachedImage(urlString: String) -> some View {
        Group {
            let imageURLString = urlString
            if !imageURLString.isEmpty {
                CachedAsyncImage(url: URL(string: imageURLString), urlCache: .imageCache) { image in
                    image.resizable()
                        .frame(minWidth: 285, minHeight: 190)
                        .scaledToFit()
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.yellow, lineWidth: 4))
                } placeholder: {
                    ProgressView()
                        .tint(Color.init(hex: "707"))
                        .scaleEffect(5)
                        .frame(height: 190)
                }
            } else {
                CachedAsyncImage(url: URL(string: zonk)) { image in
                    image.resizable()
                        .frame(minWidth: 285, minHeight: 190)
                        .scaledToFill()
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.red, lineWidth: 4))
                } placeholder: {
                    ProgressView()
                        .tint(Color.init(hex: "707"))
                        .scaleEffect(5)
                        .frame(height: 190)
                }
            }
        }
    }
}
