//
//  CutShape.swift
//  Capstone3
//
//  Created by hastu on 02/11/23.
//

import SwiftUI

struct CutShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path {
            $0.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.midY, startAngle: Angle(degrees: -5), endAngle: Angle(degrees: 5), clockwise: true)
        }
    }
}
