//
//  SearchView.swift
//  mon_dressing
//
//  Created by garry joly on 26/02/2025.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""  // Variable pour stocker le texte recherché
    @ObservedObject var viewModel: ItemViewModel
    
    var body: some View {
        VStack {
            TextField("Rechercher...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: searchText) {
                    viewModel.updateSearchText(searchText)
                }
        }
    }
}


