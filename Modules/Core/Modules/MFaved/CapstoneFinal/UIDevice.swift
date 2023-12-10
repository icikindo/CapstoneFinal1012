//
//  UIDevice.swift
//  Capstone3
//
//  Created by hastu on 02/11/23.
//

import UIKit

extension UIDevice {
    var identifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String.init(validatingUTF8: ptr)}
        }
        if modelCode == "x86_64" {
            if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { if !simModelCode.isEmpty { return simModelCode } }
        }
        return modelCode ?? "?unrecognized?"
    }
}
