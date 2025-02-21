//
//  ImagePickerController.swift
//  mon_dressing
//
//  Created by garry joly on 22/02/2025.
//

import SwiftUI
import UIKit

struct ImagePickerController: UIViewControllerRepresentable {
    @Binding var selectedImageData: Data?
    var sourceType: UIImagePickerController.SourceType

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var selectedImageData: Data?

        init(selectedImageData: Binding<Data?>) {
            _selectedImageData = selectedImageData
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage,
               let imageData = image.jpegData(compressionQuality: 0.8) {
                self.selectedImageData = imageData
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedImageData: $selectedImageData)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
