//
//  ImagePicker 2.swift
//  mon_dressing
//
//  Created by garry joly on 22/02/2025.
//
import SwiftUI


struct ImagePicker: View {
    @Binding var selectedImageData: Data?
    @State private var isSheetPresented = false
    @State private var sourceType: UIImagePickerController.SourceType? = nil

    var body: some View {
        VStack {
            Button("Choisir une photo") {
                self.sourceType = .photoLibrary
                self.isSheetPresented.toggle()
            }
            
            Button("Prendre une photo") {
                self.sourceType = .camera
                self.isSheetPresented.toggle()
            }
            
            if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
        }
        .overlay(
            BottomSheetView(isPresented: $isSheetPresented, sourceType: $sourceType)
        )
    }
}
