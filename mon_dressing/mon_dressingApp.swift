//
//  mon_dressingApp.swift
//  mon_dressing
//
//  Created by garry joly on 21/02/2025.
//

import SwiftUI
import CoreData

@main
struct Mon_dressingApp: App {
    // Créer une instance du PersistenceController pour accéder au contexte de gestion de données
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            // Passer le contexte de gestion de données à la vue ContentView
            ContentView(viewContext: persistenceController.viewContext)
                .environment(\.managedObjectContext, persistenceController.viewContext)
        }
    }
}


