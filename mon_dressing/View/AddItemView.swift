//
//  AddItemView.swift
//  mon_dressing
//
//  Created by garry joly on 21/02/2025.
//


import SwiftUI
import UIKit
import CoreData

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ItemViewModel
    
    @State private var name: String = ""
    @State private var color: String = ""
    @State private var size: String = ""
    @State private var brand: String = ""
    @State private var selectedCategory: Category?
    @State private var selectedImageData: Data?
    @State private var isActionSheetPresented = false
    @State private var sourceType: UIImagePickerController.SourceType? = nil
    @State private var isImagePickerPresented = false
    @State private var newCategoryName: String = ""  // Nouvelle catégorie
    @State private var isAddingCategory: Bool = false  // Booléen pour savoir si on affiche le champ d'ajout de catégorie
    
    // Fonction pour vérifier si tous les champs sont remplis
    private func isFormValid() -> Bool {
        return !name.isEmpty && !color.isEmpty && !size.isEmpty && !brand.isEmpty && selectedCategory != nil
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Formulaire de saisie et sélection des catégories
                Form {
                    Section(header: Text("Détails de la pièce")) {
                        TextField("Nom", text: $name)
                        TextField("Couleur", text: $color)
                        TextField("Taille", text: $size)
                        TextField("Marque", text: $brand)
                    }
                    
                    Section(header: Text("Catégorie")
                        .frame(maxWidth: .infinity, alignment: .leading))
                    {
                        VStack {
                            Picker("Sélectionner une catégorie", selection: $selectedCategory) {
                                Text("Sélectionner une catégorie")
                                    .tag(nil as Category?)
                                ForEach(viewModel.categoryManager.categories, id: \.self) { category in
                                    Text(category.name ?? "Aucune")
                                        .tag(category as Category?)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            
                            // Ajouter le bouton + pour afficher le champ de nouvelle catégorie
                            Button(action: {
                                isAddingCategory.toggle() // Affiche ou cache le champ de nouvelle catégorie
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(Color("Color"))
                                    .imageScale(.large)
                            }
                        }
                        
                        // Si isAddingCategory est true, afficher le champ pour ajouter une nouvelle catégorie
                        if isAddingCategory {
                            TextField("Nouvelle catégorie", text: $newCategoryName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            
                            Button("Ajouter une catégorie") {
                                if !newCategoryName.isEmpty {
                                    viewModel.addCategory(name: newCategoryName)
                                    newCategoryName = "" // Réinitialiser après ajout
                                    isAddingCategory = false // Cacher le champ de nouvelle catégorie
                                }
                            }
                            .padding()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 150)
                    
                    Section(header: Text("Photo")) {
                        Button("Choisir une photo") {
                            isActionSheetPresented.toggle()  // Affiche l'ActionSheet
                        }
                        .foregroundColor(Color("Color"))
                        
                        if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                    }
                    
                    
                    // Le bouton "Ajouter la pièce" qui reste ancré en bas
                    Button("Ajouter la pièce") {
                        if isFormValid() {
                            viewModel.addItem(name: name, color: color, size: size, brand: brand, category: selectedCategory, imageData: selectedImageData)
                            dismiss()
                        }
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)  // Prendre toute la largeur disponible
                    .background(isFormValid() ? Color("Color") : Color.gray)  // Couleur du bouton selon validité du formulaire
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .disabled(!isFormValid())  // Désactiver le bouton si le formulaire est invalide
                }
                .navigationTitle("Ajouter une pièce")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Annuler") {
                            dismiss()
                        }
                    }
                }
                
                // Affichage de l'ActionSheet uniquement lorsqu'il est activé
                .actionSheet(isPresented: $isActionSheetPresented) {
                    ActionSheet(
                        title: Text("Choisir une source d'image"),
                        buttons: [
                            .default(Text("Prendre une photo"), action: {
                                sourceType = .camera  // Définir la source sur la caméra
                                isImagePickerPresented.toggle()  // Affiche l'image picker
                            }),
                            .default(Text("Sélectionner depuis la galerie"), action: {
                                sourceType = .photoLibrary  // Définir la source sur la galerie
                                isImagePickerPresented.toggle()  // Affiche l'image picker
                            }),
                            .cancel(Text("Annuler"))
                        ]
                    )
                }
                // Présentation de la feuille UIImagePickerController
                .sheet(isPresented: $isImagePickerPresented) {
                    if let sourceType = sourceType {
                        ImagePickerController(selectedImageData: $selectedImageData, sourceType: sourceType)
                    }
                }
            }
        }
    }
}




    
    struct AddItemView_Previews: PreviewProvider {
        static var previews: some View {
            // Création d'un contexte simulé pour la prévisualisation
            let container = NSPersistentContainer(name: "Model")
            container.persistentStoreDescriptions = [NSPersistentStoreDescription()]
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Failed to load store: \(error.localizedDescription)")
                }
            }
            
            let viewContext = container.viewContext
            
            // Création d'un ViewModel simulé avec des données de catégorie factices
            let viewModel = ItemViewModel(viewContext: viewContext)
            let category = Category(context: viewContext)
            category.name = "Vêtements"
            viewModel.categories = [category]  // Ajouter une catégorie simulée
            
            return AddItemView(viewModel: viewModel) // Passer le viewModel simulé
        }
    }
    
    
    
    




