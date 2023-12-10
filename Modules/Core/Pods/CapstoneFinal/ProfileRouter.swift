//
//  ProfileRouter.swift
//  CapstoneFinal
//
//  Created by hastu on 27/11/23.
//

import SwiftUI

class ProfileRouter {
    func diggerView() -> some View {
        let editorUseCase = Injection.init().provideEditor()
        let presenter = EditorPresenter(editorUseCase: editorUseCase)
        return EditorView(presenter: presenter)
    }
}
