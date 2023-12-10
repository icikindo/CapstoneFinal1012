//
//  TabItem.swift
//  CapstoneFinal
//
//  Created by hastu on 27/11/23.
//

import SwiftUI

struct TabItem: View {
  var imageName: String
  var title: String
  var body: some View {
    VStack {
      Image(systemName: imageName)
      Text(title)
    }
  }
}
