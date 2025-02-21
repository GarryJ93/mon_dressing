//
//  BottomSheetView(.swift
//  mon_dressing
//
//  Created by garry joly on 22/02/2025.
//

import SwiftUI

struct BottomSheetView: View {
    @Binding var isPresented: Bool
    @Binding var sourceType: UIImagePickerController.SourceType?
    
    @State private var offset: CGFloat = 500 // Start position off-screen

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                if isPresented {
                    VStack(spacing: 20) {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.isPresented = false
                            }) {
                                Text("Annuler")
                                    .padding()
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        VStack(spacing: 16) {
                            Button("Choisir depuis la galerie") {
                                self.sourceType = .photoLibrary
                                self.isPresented = false
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            
                            Button("Prendre une photo") {
                                self.sourceType = .camera
                                self.isPresented = false
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                        .padding(.bottom, 20)
                    }
                    .frame(width: geometry.size.width)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .offset(y: offset)
                    .onAppear {
                        withAnimation(.spring()) {
                            offset = 0 // Slide up when the sheet is presented
                        }
                    }
                    .onChange(of: isPresented) {
                        if !isPresented{
                            withAnimation(.spring()) {
                                offset = geometry.size.height // Slide down when dismissed
                            }
                        }
                    }
                }
            }
        }
        .background(Color.black.opacity(0.4).onTapGesture {
            self.isPresented = false
        })
        .edgesIgnoringSafeArea(.bottom)
    }
}

