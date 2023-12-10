//
//  EditorPresenter.swift
//  CapstoneFinal
//
//  Created by hastu on 27/11/23.
//

import SwiftUI

class EditorPresenter: ObservableObject {
    private let editorUseCase: EditorUseCase
    init(editorUseCase: EditorUseCase) {
        self.editorUseCase = editorUseCase
    }
}
