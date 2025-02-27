//
//  DressingView.swift
//  mon_dressing
//
//  Created by garry joly on 23/02/2025.
//
import SwiftUI

struct DressingView: View {
    @EnvironmentObject var viewModel: ItemViewModel // Utilise EnvironmentObject ici
    @Binding var showAddItemView: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    SearchView(viewModel: viewModel)
                        .padding(.horizontal)
                    CategoryFilterView(viewModel: viewModel)
                        .padding(.horizontal)
                }
                
                
                // Affichage des items filtrés
                if viewModel.filteredItems.isEmpty {
                    Spacer()
                    Text("Aucun vêtement à afficher")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(viewModel.filteredItems) { item in
                                ItemCardView(item: item)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitle("Mon Dressing")
            .navigationBarItems(
                trailing: Button(action: {
                    showAddItemView.toggle()
                }) {
                    Label("Ajouter un item", systemImage: "plus")
                }
            )
            .sheet(isPresented: $showAddItemView) {
                AddItemView(viewModel: viewModel)
            }
            
            
            .onAppear {
                // Personnalisation de la barre de navigation
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground() // Vous pouvez aussi laisser ce paramètre selon vos préférences
                
                // Définir la couleur du titre
                appearance.titleTextAttributes = [
                    .foregroundColor: UIColor.color // Changer ici pour la couleur de votre choix
                ]
                
                // Définir la couleur pour le grand titre si nécessaire
                appearance.largeTitleTextAttributes = [
                    .foregroundColor: UIColor.color // Changer ici pour la couleur du grand titre
                ]
                
                // Appliquer l'apparence personnalisée à la navigation bar
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
            
        }
    }
}


