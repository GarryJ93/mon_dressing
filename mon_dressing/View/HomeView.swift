//
//  HomeView.swift
//  mon_dressing
//
//  Created by garry joly on 23/02/2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Bienvenue dans")
                .font(.title)
                .foregroundColor(.gray)
            Image("logo")  // Remplace "logo" par ton image dans les assets
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)  // Ou toute autre couleur que tu veux
        .edgesIgnoringSafeArea(.all) // Prendre tout l'écran
       
            }
        }
    

#Preview {
    HomeView()
}
