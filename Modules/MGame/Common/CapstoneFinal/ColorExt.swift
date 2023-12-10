//
//  ColorExt.swift
//  Capstone3
//
//  Created by hastu on 01/11/23.
//

import SwiftUI

extension Color {
  static var random: Color {
    return Color(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1)
    )
  }

  init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let acc, rcc, gcc, bcc: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (acc, rcc, gcc, bcc) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (acc, rcc, gcc, bcc) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (acc, rcc, gcc, bcc) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (acc, rcc, gcc, bcc) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(rcc) / 255,
            green: Double(gcc) / 255,
            blue: Double(bcc) / 255,
            opacity: Double(acc) / 255
        )
    }
}
