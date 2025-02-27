//
//  CategoryFilterView.swift
//  mon_dressing
//
//  Created by garry joly on 23/02/2025.
//

import SwiftUI

struct CategoryFilterView: View {
    @ObservedObject var viewModel: ItemViewModel
    var body: some View {
        // Affichage des filtres de catégorie sous forme de boutons de type checkbox
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.itemsCategories, id: \.self) { category in
                    Button(action: {
                        viewModel.toggleCategorySelection(category: category)
                    }) {
                        HStack {
                            Text(category)
                        }
                        .padding(8)
                        .background(viewModel.itemFilterManager.selectedCategories.contains(category) ? Color("Color"): Color.gray.opacity(0.5))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

