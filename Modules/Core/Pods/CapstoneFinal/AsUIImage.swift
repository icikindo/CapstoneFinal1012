//
//  AsUIImage.swift
//  CapstoneFinal
//
//  Created by hastu on 04/12/23.
//
import SwiftUI

extension View {
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        controller.view.backgroundColor = .clear

        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        scene?.windows.first?.rootViewController?.view.addSubview(controller.view)

        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()

        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        return paths[0]
    }

     func retrieveImage(from filename: String) -> UIImage? {
         let url = URL.documentsDirectory.appendingPathComponent(filename)
         do {
             let imageData = try Data(contentsOf: url)
             return UIImage(data: imageData)
         } catch {
             return nil
         }
     }
}

extension UIView {
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
