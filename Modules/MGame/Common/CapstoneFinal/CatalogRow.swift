//
//  CatalogRow.swift
//  CapstoneFinal
//
//  Created by hastu on 30/11/23.
//

import SwiftUI
import Core
import MCatalog
import MFaved
import MGame

struct CatalogRow: View {
    @ObservedObject var presenter: GetItemPresenter<Any, CoreDomainModel,
       Interactor<Any, CoreDomainModel, GetGameRepository<GetRemoteGameSource, GetLocaleData, GameTransformer>>>
    var catalog: CatalogDomainModel
    @Binding var alreadyFaveds: String
    @State var totalFaved: Int = 0
    @State private var inFaved = false
    @State private var hearted = "heart.slash"
    @ObservedObject var user = UserDefaulte()

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

extension CatalogRow {
    var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            let nameLength = catalog.name.count
            let nameSize = nameLength < 30 ? 18.0 : 14.0
            let nameTrack = nameLength < 20 ? 2.0 : 1.0
            HStack {
                (Text(Image(systemName: "star.fill")).foregroundColor(.yellow) + Text(verbatim: " \(catalog.rating) [\(catalog.ratingsCount) votes]"))
                    .font(.custom("Inconsolata", size: 16))
                Spacer()
                Image(systemName: hearted)
                    .resizable()
                    .scaledToFit()
                    .imageScale(.large)
                    .foregroundColor(.red)
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 8)
            }

            Text(catalog.name)
                .font(.custom("Pointer", size: nameSize))
                .tracking(nameTrack)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 8)
            if !catalog.image.isEmpty {
                displayPicture
            } else {
                zonderDP
            }
            HStack {
                Spacer()
                Text("Genre: \(catalog.genres)")
                    .font(.callout)
            }.padding(.top, 4)
      }.padding( // Vstack
        EdgeInsets(
          top: 4,
          leading: 16,
          bottom: 8,
          trailing: 16
        )
      )
      .task {
          presenter.check(catalog.id)
      }
      .onChange(of: presenter.inFaved) { _ in
          hearted = "heart.fill"
          totalFaved += 1
          let keyIndex = "\(catalog.id)|"
          alreadyFaveds.append(keyIndex)
      }
    }

    var displayPicture: some View {
        HStack {
            Spacer()
            CachedAsyncImage(url: URL(string: catalog.image)) { image in
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
