//
//  GameBody.swift
//  CapstoneFinal
//
//  Created by hastu on 30/11/23.
//

import SwiftUI
import Core
import MFaved
import MGame

struct GameBody: View {
    @ObservedObject var presenter: GetItemPresenter<Any, CoreDomainModel,
       Interactor<Any, CoreDomainModel, GetGameRepository<GetRemoteGameSource, GetLocaleData, GameTransformer>>>
    let theGame: CoreDomainModel
    @AppStorage("language") var language = LocalizationService.shared.language

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.currentTab) var tab
    @State private var isExpanded: Bool = false
    @State private var theNote = ""
    @FocusState private var textFieldFocused: Bool

    private enum Field: Int, CaseIterable {
        case notes
    }
    @FocusState private var focusedField: Field?
    @State var initialNote = ""

    var body: some View {
        VStack {
            content
        }
        .frame(width: UIScreen.main.bounds.width - 32)
    }

    func togel() {
        isExpanded.toggle()
    }

    func readMore() -> some View {
        Text(isExpanded ? "Less".localized(language) : "Read More".localized(language))
            .font(.system(size: 12))
            .padding(.horizontal, 8.0)
            .padding(.vertical, 4.0)
            .background(Color.blue.opacity(0.7))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .offset(x: 0, y: isExpanded ? 12 : 2)
    }

    func saveButton() -> some View {
        Text("Save".localized(language))
            .font(.system(size: 16))
            .padding(.horizontal, 12.0)
            .padding(.vertical, 4.0)
            .background(presenter.wasNoted ? Color.blue.opacity(0.7) : Color.gray)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }

    func saveNote () {
        if !presenter.inFaved {
            presenter.fave(theGame: theGame)
            presenter.save(id: theGame.id)
            presentationMode.wrappedValue.dismiss()
            tab.wrappedValue = .faved
        } else {
            presenter.save(id: theGame.id)
            initialNote = presenter.theNote
        }
    }
 }

extension GameBody {
    var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            let desc = theGame.desc
            let webLabel = theGame.web.count > 45 ? String(theGame.web.prefix(45)+"...") : theGame.web
            let rawgRef = URL(string: EndPoints.Gets.slug.url + theGame.slug)
            Text(desc
                .replacingOccurrences(of: "\r\n", with: "\n")
                .replacingOccurrences(of: "\\n*", with: "\n"))
            .font(.caption2)
                .foregroundColor(Color.init(hex: "008"))
                .lineLimit(isExpanded ? nil: 3)
                .overlay(
                    GeometryReader { proxy in
                        if desc.count > 120 {
                            Button(action: togel, label: readMore)
                                .frame(width: proxy.size.width, height: isExpanded ?
                                       (proxy.size.height + 5) : (proxy.size.height + 15), alignment: .bottomTrailing).opacity(presenter.isLoading ? 0 : 1)
                        }
                    }
                )
            Text("Website:")
                .font(.system(size: 12))
                .padding(.top, 16)
            if let theUrl = URL(string: theGame.web) {
                Link(webLabel, destination: theUrl)
                    .font(.system(size: 14))
                    .foregroundColor(.blue)
                    .underline(true, color: .blue)
            } else {
                Text("None".localized(language))
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            ( Text("RAWG: ").tracking(2.0) + Text(" \(theGame.slug) ") )
                .background(.black)
                .foregroundColor(.white)
                .font(.system(size: 14))
                .padding(.vertical, 8)
                .onTapGesture {
                    UIApplication.shared.open(rawgRef!)
                }

            VStack(alignment: .leading) {
                TextField(" " + "My note for".localized(language) + " \(theGame.name)", text: $presenter.theNote, axis: .vertical)
                    .focusablePadding(.vertical, 4)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 14))
                    .foregroundColor(Color.init(hex: "00b"))
                    .frame(maxWidth: 360, alignment: .leading)
                    .frame(height: 48)
                    .textFieldStyle(PlainTextFieldStyle())
                    .background(LinearGradient(gradient: Gradient(colors: [Color.init(hex: "ff0"), Color.init(hex: "cff")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .focused($focusedField, equals: .notes)
                    .focused($textFieldFocused)
                    .onLongPressGesture(minimumDuration: 0.0) {
                        textFieldFocused = true
                    }
                    .autocorrectionDisabled()
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done".localized(language)) {
                        focusedField = nil
                    }
                }
            }
            .onChange(of: presenter.theNote) { newValue in
                if initialNote.isEmpty && !newValue.isEmpty {
                    initialNote = newValue
                }
                presenter.wasNoted = presenter.theNote != initialNote
            }
            HStack {
                Spacer()
                Button(action: {
                    if presenter.wasNoted {
                        saveNote()
                    }
                }, label: saveButton)
                .padding(.vertical, 8)
            }
        }
    }

}

extension TextField {
    func focusablePadding(_ edges: Edge.Set = .all, _ size: CGFloat? = nil) -> some View {
        modifier(FocusablePadding(edges, size))
    }
}

private struct FocusablePadding: ViewModifier {

    private let edges: Edge.Set
    private let size: CGFloat?
    @FocusState private var focused: Bool

    init(_ edges: Edge.Set, _ size: CGFloat?) {
        self.edges = edges
        self.size = size
        self.focused = false
    }

    func body(content: Content) -> some View {
        content
            .focused($focused)
            .padding(edges, size)
            .contentShape(Rectangle())
            .onTapGesture { focused = true }
    }

}
