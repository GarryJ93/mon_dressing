//
//  ImagePickerView 2.swift
//  mon_dressing
//
//  Created by garry joly on 22/02/2025.
//
import SwiftUI


struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImageData: Data?
    var sourceType: UIImagePickerController.SourceType?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedImageData: $selectedImageData)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType ?? .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        uiViewController.sourceType = sourceType ?? .photoLibrary
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var selectedImageData: Data?
        
        init(selectedImageData: Binding<Data?>) {
            _selectedImageData = selectedImageData
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage,
               let data = image.jpegData(compressionQuality: 0.8) {
                selectedImageData = data
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

