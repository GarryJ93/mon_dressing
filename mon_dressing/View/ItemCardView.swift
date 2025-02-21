//
//  ItemCardView.swift
//  mon_dressing
//
//  Created by garry joly on 21/02/2025.
//

import SwiftUI
import CoreData

struct ItemCardView: View {
    var item: Item
    var body: some View {
        NavigationLink(destination: ItemDetailView(item: item)) {
            VStack {
                // Affichage de l'image de l'item (si elle existe)
                if let imageData = item.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5) // Ombre de l'image
                } else {
                    // Image de remplacement si aucune image n'est présente
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5) // Ombre de l'image
                }
                
                // Affichage du nom et de la catégorie de l'item
                VStack {
                    Text(item.name ?? "Unnamed Item")
                        .font(.headline)
                        .foregroundColor(.gray)
                    VStack(alignment: .leading, spacing: 4 ) {
                        if let category = item.category {
                            Text("\(category.name ?? "No Category")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Text("Taille : \(item.size ?? "No Size ")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Couleur : \(item.color ?? "No Color ")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Marque : \(item.brand ?? "No Brand ")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .frame(maxWidth: 200, maxHeight: 320)
            .background(Color.white) // Applique un fond blanc pour la carte
            .cornerRadius(20)  // Coins arrondis pour la carte
            .overlay(
                RoundedRectangle(cornerRadius: 20)  // Appliquer la bordure autour du contenu
                .stroke(Color("Color"), lineWidth: 2)  // Appliquer la bordure
                    )
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5) // Ombre à l'extérieur de la carte
            .padding([.top, .bottom], 5)

            
        }
    }
}


