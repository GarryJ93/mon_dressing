//
//  ItemDetailView 2.swift
//  mon_dressing
//
//  Created by garry joly on 22/02/2025.
//
import SwiftUI
import CoreData

struct ItemDetailView: View {
    @EnvironmentObject var viewModel: ItemViewModel // Utilise EnvironmentObject ici
    var item: Item
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var isImageFullScreen = false // Variable d'état pour afficher l'image en plein écran
    @State private var showingDeleteConfirmation = false
    
    init(item: Item) {
        self.item = item
    }
    
    // Fonction pour supprimer un item en appelant la méthode du ViewModel
    private func deleteItem() {
        viewModel.deleteItem(item: item)  // Appel de deleteItem dans le ViewModel
        dismiss()
    }
    
    var body: some View {
        VStack {
            // Utiliser une card avec des coins arrondis
            VStack {
                Spacer()
                
                // Image avec coins arrondis et ombre
                if let imageData = item.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill) // L'image remplit le cadre sans être déformée
                        .frame(maxWidth: .infinity, minHeight: 250) // Taille du cadre
                        .clipShape(RoundedRectangle(cornerRadius: 20)) // Coins arrondis
                        .clipped() // Cela permet de s'assurer que l'image est recadrée correctement et ne dépasse pas les bords arrondis
                        .padding()
                        .shadow(radius: 10) // Ombre subtile
                        .onTapGesture {
                            isImageFullScreen.toggle()
                        }
                    
                } else {
                    // Image de remplacement avec le même style
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 320, minHeight: 250) // Taille du cadre
                        .clipShape(RoundedRectangle(cornerRadius: 20)) // Coins arrondis
                        .padding()
                        .shadow(radius: 10) // Ombre subtile
                    
                }
                
                Spacer()
                
                // Détails de l'item avec coins arrondis et bordure
                HStack {
                    if let category = item.category {
                        Text("\(category.name ?? "No Category")")
                            .font(.title3)
                            .foregroundColor(Color("Color"))
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Marque : \(item.brand ?? "No Brand")")
                            .font(.subheadline)
                        Text("Couleur : \(item.color ?? "No Color ")")
                            .font(.subheadline)
                        Text("Taille : \(item.size ?? "No Size ")")
                            .font(.subheadline)
                    }
                    .padding(.top, 5)
                    .foregroundColor(.gray)
                }
                .padding()  // Ajout de padding autour du HStack
                .background(
                    RoundedRectangle(cornerRadius: 20)  // Appliquer les coins arrondis sur un fond
                        .stroke(Color("Color"), lineWidth: 1)  // Appliquer la bordure autour du contenu
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))  // Appliquer les coins arrondis sur l'ensemble du HStack


                
                Spacer()
                
                // Bouton pour supprimer avec confirmation
                Button(action: {
                    showingDeleteConfirmation = true  // Afficher l'alerte de confirmation
                }) {
                    Text("Supprimer")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)  // Prendre toute la largeur disponible
                        .background(Color.red)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding([.leading, .trailing], 20)
                .alert(isPresented: $showingDeleteConfirmation) {
                    Alert(
                        title: Text("Confirmer la suppression"),
                        message: Text("Êtes-vous sûr de vouloir supprimer cet item ?"),
                        primaryButton: .destructive(Text("Supprimer")) {
                            deleteItem()  // Supprimer l'item si l'utilisateur confirme
                        },
                        secondaryButton: .cancel()  // Annuler l'action
                    )
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 25).fill(Color.clear).shadow(radius: 15)) // Card avec coins arrondis et ombre
            .padding(.horizontal)
            .navigationBarTitle("\(item.name ?? "Erreur")", displayMode: .inline)
            .sheet(isPresented: $isImageFullScreen) {
                if let imageData = item.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .edgesIgnoringSafeArea(.all) // Pour que l'image occupe tout l'écran
                        .onTapGesture {
                            isImageFullScreen.toggle()
                        }
                }
            }
            
        }}
    
    // Prévisualisation
    
    
    struct ItemDetailView_Previews: PreviewProvider {
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
            
            // Création d'un item simulé
            let item = Item(context: viewContext)
            item.name = "Exemple de Vêtement"
            item.size = "M"
            item.color = "Rouge"
            item.brand = "Exemple de Marque"
            item.imageData = nil // Pas d'image pour cet exemple
            item.category = Category(context: viewContext)
            item.category?.name = "Vêtements"
            
            // Prévisualisation de la vue avec l'item simulé
            return NavigationView {
                ItemDetailView(item: item)
            }
        }
    }
}



