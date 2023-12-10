//
//  EditorView.swift
//  CapstoneFinal
//
//  Created by hastu on 06/12/23.
//

import SwiftUI
import PhotosUI
import Combine

struct EditorView: View {
    @ObservedObject var presenter: EditorPresenter
    @Environment(\.presentationMode) var presentationMode
    @State private var profileItem: PhotosPickerItem?

    private let noPicture = Image("canvas", bundle: Bundle(identifier: "f43.app.Common")).asUIImage()
    @State private var profilePicture: UIImage = Image("canvas", bundle: Bundle(identifier: "f43.app.Common")).asUIImage()
    @ObservedObject var user = UserDefaulte()
    @State private var lastName = ""
    @State private var lastBrief = ""
    @State private var lastPhoto = ""
    @FocusState private var nameFieldFocused: Bool
    @FocusState private var briefFieldFocused: Bool
    @State private var userOwnName = ""
    @State private var userBrief = ""
    @State private var userPhoto = ""
    let maxNameLength = 24
    @AppStorage("language") private var language = LocalizationService.shared.language
    @State private var userLang: Language = userDefaultLanguage

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                content
            }
        }
    }

    internal func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }

    internal func isEditing() -> Bool {
        if userOwnName.count < 3 || userBrief.count < 3 {
            return false
        }
        if lastName != userOwnName || lastBrief != userBrief {
            return true
        }
        if userLang != language {
            return true
        }
        return false
    }

    internal func isBlank() -> Bool {
        if userOwnName.isEmpty && userBrief.isEmpty && userPhoto.isEmpty {
            return true
        }
        return false
    }

    internal func isCancelable() -> Bool {
        if lastName != userOwnName || lastBrief != userBrief || lastPhoto != userPhoto || userLang != language {
            return true
        }
        return false
    }

    internal func limitNameText(_ upper: Int) {
        userOwnName = userOwnName.components(separatedBy: CharacterSet.decimalDigits).joined()
        if userOwnName.count > upper {
            userOwnName = String(userOwnName.prefix(upper))
        }
    }

    // MARK: - getURL
   internal func getURL(item: PhotosPickerItem, completionHandler: @escaping (_ result: Result<URL, Error>) -> Void) {
       // Step 1: Load as Data object.
       item.loadTransferable(type: Data.self) { result in
           switch result {
           case .success(let data):
               if let contentType = item.supportedContentTypes.first {
                   // Step 2: make the URL file name and a get a file extention.
                   let url = getDocumentsDirectory().appendingPathComponent("\(UUID().uuidString).\(contentType.preferredFilenameExtension ?? "")")
                   if let data = data {
                       do {
                           // Step 3: write to temp App file directory and return in completionHandler
                           try data.write(to: url)
                           completionHandler(.success(url))
                       } catch {
                           completionHandler(.failure(error))
                       }
                   }
               }
           case .failure(let failure):
               completionHandler(.failure(failure))
           }
       }
   }
}

extension EditorView {
    var content: some View {
        GeometryReader { metrics in
            VStack {
                VStack {
                    let imgWidth = metrics.size.width * 0.5
                    let imgHeight = 4.2 * imgWidth / 2.9

                    LanguageSetting(language: $userLang)
                        .frame(height: 60)

                    HStack {
                        Text("name".localized(userLang))
                        Text(":")
                            .padding(.horizontal, 6)
                            .bold()
                        TextField("type_your_name", text: $userOwnName)
                            .keyboardType(.alphabet)
                            .font(.callout)
                            .tracking(2.0)
                            .padding(.leading, 12)
                            .padding(.vertical, 4)
                            .background(.white)
                            .foregroundColor(.black)
                            .onReceive(Just(userOwnName)) { _ in limitNameText(maxNameLength) }
                            .focused($nameFieldFocused)
                            .onLongPressGesture(minimumDuration: 0.0) {
                                nameFieldFocused = true
                            }
                            .autocorrectionDisabled()
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1).foregroundColor(.gray))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)

                    TextField("how_are_you".localized(userLang), text: $userBrief)
                        .font(.callout)
                        .padding(.leading, 4)
                        .padding(.vertical, 4)
                        .background(.white)
                        .foregroundColor(.black)
                        .focused($briefFieldFocused)
                        .onLongPressGesture(minimumDuration: 0.0) {
                            briefFieldFocused = true
                        }
                        .disableAutocorrection(true)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1).foregroundColor(.gray))
                    HStack {
                        Spacer()
                        Text("description".localized(userLang))
                            .font(.system(size: 12))
                            .padding(.trailing, 4)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)

                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: profilePicture)
                            .resizable()
                            .scaledToFit()
                            .frame(width: imgWidth, height: imgHeight)
                            .cornerRadius(5)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.white.opacity(0.5), style: StrokeStyle(lineWidth: 3, dash: [5]))
                            )
                            .background(Color.gray)
                            .onAppear {
                                if !userPhoto.isEmpty {
                                    profilePicture = retrieveImage(from: userPhoto) ?? noPicture
                                } else {
                                    profilePicture = Image("pasfoto", bundle: Bundle(identifier: "f43.app.Common")).asUIImage()
                                }
                            }
                        PhotosPicker(selection: $profileItem, matching: .images ) {
                            Label("profile_picture".localized(userLang), systemImage: "square.and.arrow.up")
                                .padding(.vertical, 4)
                                .font(.system(size: 14))
                        }
                        .frame(width: imgWidth * 0.8)
                        .foregroundColor(.black)
                        .background(Color.yellow.opacity(0.7))
                        .cornerRadius(10.0)
                        .padding(.top, 4)
                        .padding(.trailing, 2)
                    }
                    .onChange(of: profileItem) { _ in
                        getURL(item: profileItem!) { result in
                            switch result {
                            case .success(let url):
                                let filename = url.lastPathComponent
                                profilePicture = retrieveImage(from: filename) ?? noPicture
                                Task {
                                    userPhoto = filename
                                }
                            case .failure(let failure):
                                print(failure.localizedDescription)
                            }
                        }
                    }

                    Text("edit_profile".localized(userLang))
                        .font(.headline)
                        .bold()
                        .padding()
                        .foregroundColor(.white)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.black)
                                .shadow(color: .gray, radius: 2, x: 2, y: 4)
                        }
                        .onAppear {
                            userOwnName = user.ownName
                            userBrief = user.brief
                            userLang = language
                            userPhoto = user.profilePicture
                            lastName = userOwnName
                            lastBrief = userBrief
                            lastPhoto = userPhoto
                        }
                    HStack {
                        Button(action: {
                            if !isBlank() {
                                profilePicture = Image("pasfoto", bundle: Bundle(identifier: "f43.app.Common")).asUIImage()
                                user.ownName = ""
                                user.brief = ""
                                user.profilePicture = ""
                                dismiss()
                            }
                        }, label: {
                            Text("RESET")
                                .foregroundColor(isBlank() ? Color.gray : Color.white)
                                .font(.headline)
                                .frame(width: 80, height: 80)
                                .background(Color.red.opacity(isBlank() ? 0.1 : 0.9))
                                .clipShape(Circle()).padding(5)
                                .overlay(
                                    RotatedShape(shape: CutShape(), angle: .degrees(-45))
                                        .stroke(Color.green, lineWidth: 3)
                                )
                        })
                        Spacer()
                        Button(action: {
                            if isCancelable() {
                                user.ownName = lastName
                                user.brief = lastBrief
                                user.profilePicture = lastPhoto
                                dismiss()
                            }
                        }, label: {
                            Text("undo".localized(userLang))
                                .foregroundColor(isCancelable() ? Color.black : Color.gray)
                                .font(.headline)
                                .frame(width: 80, height: 80)
                                .background(Color.yellow.opacity(isCancelable() ? 0.8 : 0.2))
                                .clipShape(Circle()).padding(5)
                                .overlay(
                                    RotatedShape(shape: CutShape(), angle: .degrees(-90))
                                        .stroke(Color.red, lineWidth: 3)
                                )
                        })

                        Spacer()
                        Button(action: {
                            if isEditing() {
                                //
                                // Minimize breakpoint symbolic: print_cycle
                                // "=== AttributeGraph: cycle detected through attribute %u ===\n"
                                //
                                if language != userLang {
                                    language = userLang
                                }
                                if user.ownName != userOwnName {
                                    user.ownName = userOwnName
                                }
                                if user.brief != userBrief {
                                    user.brief = userBrief
                                }
                                if user.profilePicture != userPhoto {
                                    user.profilePicture = userPhoto
                                }
                                dismiss()
                            }
                        }, label: {
                            Text("save".localized(userLang))
                                .foregroundColor(isEditing() ? Color.white : Color.init(hex: "ddf"))
                                .font(.headline)
                                .frame(width: 80, height: 80)
                                .background( Color.blue.opacity(isEditing() ? 0.9 : 0.4))
                                .clipShape(Circle()).padding(5)
                                .overlay(
                                    RotatedShape(shape: CutShape(), angle: .degrees(-145))
                                        .stroke(Color.yellow, lineWidth: 3)
                                )
                        })
                    }
                    .padding(.top, 12)

                    Spacer()
                }.frame(maxWidth: metrics.size.width * 0.9)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
