//
//  ContentView.swift
//  mon_dressing
//
//  Created by garry joly on 21/02/2025.
//
import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: ItemViewModel
    @State private var showLogo: Bool = true // Afficher ou non le logo
    @State private var showAddItemView = false
    
    // Sélection des catégories filtrées
    @State private var selectedCategories: Set<String> = [] // Utiliser Set<String> au lieu de Set<Category>
    
    init(viewContext: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: ItemViewModel(viewContext: viewContext))
    }
    
    var body: some View {
        ZStack {
            // 1. Affichage du logo pendant un délai
            if showLogo {
                HomeView()
                    .onAppear {
                        // Délai avant de passer à la vue principale
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                showLogo = false // Cache le logo après 5 secondes
                            }
                        }
                    }
            } else {
                // 2. Affichage de la vue principale une fois le logo disparu
                DressingView(
                    showAddItemView: $showAddItemView
                )
                .environmentObject(viewModel)
                .onAppear {
                    // Mettre à jour filteredItems à chaque apparition de la vue
                    viewModel.fetchItems()
                }
            }
        }
    }
}



        
