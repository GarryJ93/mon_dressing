//
//  Persistence.swift
//  mon_dressing
//
//  Created by garry joly on 21/02/2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    // Conteneur NSPersistentContainer
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "mon_dressing") // Assurez-vous que ce nom correspond au modèle CoreData

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        // Appeler la méthode pour initialiser les catégories par défaut
        initializeDefaultCategories()
    }

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    // Méthode pour ajouter des catégories par défaut si elles n'existent pas
    private func initializeDefaultCategories() {
        let context = container.viewContext

        // Vérifier si des catégories existent déjà
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            let categories = try context.fetch(fetchRequest)

            // Si aucune catégorie n'existe, on en crée
            if categories.isEmpty {
                addDefaultCategories(to: context)
            }
        } catch {
            print("Erreur lors de la récupération des catégories: \(error)")
        }
    }

    // Méthode pour ajouter des catégories par défaut
    private func addDefaultCategories(to context: NSManagedObjectContext) {
        let defaultCategories = ["T-shirt", "Jeans", "Chaussures", "Chemise", "Pull", "Sweat", "Pantalon", "Short", "Veste", "Manteau", "Blouson"]

        for categoryName in defaultCategories {
            let category = Category(context: context)
            category.name = categoryName
        }

        // Sauvegarder les changements dans la base de données
        do {
            try context.save()
        } catch {
            print("Erreur lors de la sauvegarde des catégories par défaut: \(error)")
        }
    }
}



