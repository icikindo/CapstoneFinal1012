//
//  FavedAction.swift
//  CapstoneFinal
//
//  Created by hastu on 01/12/23.
//

import SwiftUI
import Core
import MFaved

struct FavedAction: View {
    @ObservedObject var presenter: GetListPresenter<Any, FavedDomainModel,
        Interactor<Any, [FavedDomainModel], GetFavedRepository<GetLocaleData, FavedTransformer>>>

    @ObservedObject var user = UserDefaulte()
    @State private var isPresentingConfirm: Bool = false

    var body: some View {
        VStack {
            content
        }
        .frame(width: UIScreen.main.bounds.width - 32)
    }

    func unFaveMarkedItems() {

    }

    func cleanUpLocal() {

    }
}

extension FavedAction {
    var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            let checkedCount = user.checked.components(separatedBy: "|").count-1
            Divider()
                .frame(height: 4)
                .overlay(.indigo)
                .padding(.vertical, 8)

            HStack {
                Spacer()
                Text("Mark your faved games as important")
                    .font(.system(size: 14))
                    .foregroundColor(.blue)
                    .italic()
                Spacer()
            }
            .padding(.top, 12)
            .padding(.bottom, 4)
            HStack {
                Spacer()
                Button(action: {
                    let idArray = presenter.list.map({ (faved: FavedDomainModel) -> String in
                        "\(faved.id)|"
                    })
                    user.checked = idArray.joined()
                }, label: {
                    Text("Mark All")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(checkedCount < presenter.available ? .white : .gray)
                        .padding(.vertical, 4)
                        .frame(minWidth: 0, maxWidth: 100)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(checkedCount < presenter.available ? Color.blue : Color.init(hex: "ddd"))
                                .shadow(color: .gray, radius: 2, x: 0, y: 2)
                        )
                })
                Spacer()
                Button(action: {
                    user.checked = ""
                }, label: {
                    Text("Clear Mark")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(checkedCount > 0 ? .white : .gray)
                        .padding(.vertical, 4)
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: 100)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(checkedCount > 0 ? Color.blue : Color.init(hex: "#ddd"))
                                .shadow(color: .gray, radius: 2, x: 0, y: 2)
                        )
                })
                Spacer()
            }
            HStack {
                Spacer()
                if checkedCount > 0 {
                    Button(action: {
                        unFaveMarkedItems()
                    }, label: {
                        Text("Unfave Marked Items")
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                            .foregroundColor(checkedCount > 0 ? .black : .gray)
                            .frame(minWidth: 0, maxWidth: 220)
                            .frame(height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(checkedCount > 0 ? Color.init(hex: "ff0") : Color.init(hex: "#ddd"))
                                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                            )
                    })
                } else {
                    Button("Remove All Items from Favorite", role: .destructive) {
                        isPresentingConfirm = true
                    }
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: 280)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.init(hex: "#d00"))
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    )
                    .buttonStyle(.borderedProminent)
                    .confirmationDialog("ARE YOU SURE?", isPresented: $isPresentingConfirm, titleVisibility: .visible) {
                        Button("Yes", role: .destructive) {
                            cleanUpLocal()
                        }
                        Button("Not", role: .cancel) {}
                    } message: {
                        Text("If you are not sure then do not tap the Yes button)")
                    }
                }
                Spacer()
            }
            .padding(.top, 20)
            .padding(.bottom, 30)
        }
    }
}
