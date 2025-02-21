//
//  ItemViewModel.swift
//  mon_dressing
//
//  Created by garry joly on 21/02/2025.
//

import SwiftUI
import CoreData

class ItemViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var filteredItems: [Item] = []
    
    @Published var categories: [Category] = []
    @Published var itemsCategories: [String] = []  // Contiendra les noms des catégories
    @Published var itemsBrands: [String] = []
    
    @Published var selectedCategories: Set<String> = []
    
    private var viewContext: NSManagedObjectContext
    
    // Sous-modèle pour la gestion des items
    struct ItemManager {
        var items: [Item]
        var viewContext: NSManagedObjectContext
        var itemFilter: ItemFilterManager
        var itemsCategories: [String] = [] 
        
        // Récupérer les items depuis CoreData
        mutating func fetchItems() {
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            let sortDescriptor = NSSortDescriptor(keyPath: \Item.name, ascending: true)
            request.sortDescriptors = [sortDescriptor]
            
            do {
                self.items = try viewContext.fetch(request)
                itemFilter.updateFilteredItems(allItems: self.items)
            } catch {
                print("Error fetching items: \(error)")
            }
        }
        
        // Ajouter un item
        mutating func addItem(uuid: UUID, name: String, color: String, size: String, brand: String, category: Category?, imageData: Data?) {
            guard !name.isEmpty, !color.isEmpty, !size.isEmpty, !brand.isEmpty, let category = category else {
                print("Tous les champs obligatoires doivent être remplis.")
                return
            }
            
            let newItem = Item(context: viewContext)
            newItem.uuid = uuid
            newItem.name = name
            newItem.color = color
            newItem.size = size
            newItem.brand = brand
            newItem.category = category
            newItem.imageData = imageData
            saveContext()
        }
        
        // Supprimer un item
         mutating func deleteItem(item: Item) {
              viewContext.delete(item)
              saveContext()
          }
        
        // Extraire les catégories uniques en tant que noms de catégories (strings)
        mutating func extractCategories(items: [Item]) {
            // Extraire les catégories uniques en récupérant uniquement le nom
            let allCategories = Set(items.compactMap { $0.category?.name })
            self.itemsCategories = Array(allCategories).sorted()
            
        }
        
        
        private func saveContext() {
            do {
                if viewContext.hasChanges {
                    try viewContext.save()
                }
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // Sous-modèle pour gérer le filtrage des items
    struct ItemFilterManager {
        var selectedCategories: Set<String> = []
        var filteredItems: [Item] = []
        
        // Mettre à jour les items filtrés
        mutating func updateFilteredItems(allItems: [Item]) {
            if selectedCategories.isEmpty {
                filteredItems = allItems
            } else {
                filteredItems = allItems.filter { item in
                    guard let categoryName = item.category?.name else { return false }
                    return selectedCategories.contains(categoryName)
                }
            }
        }
        
        // Mettre à jour les catégories sélectionnées
        mutating func toggleCategorySelection(category: String) {
            if selectedCategories.contains(category) {
                selectedCategories.remove(category)
            } else {
                selectedCategories.insert(category)
            }
        }
    }
    
    // Sous-modèle pour la gestion des catégories
    struct CategoryManager {
        var categories: [Category]
        var viewContext: NSManagedObjectContext
        var itemsCategories: [String] = []
        
        // Récupérer les catégories depuis CoreData
        mutating func fetchCategories() {
            let request: NSFetchRequest<Category> = Category.fetchRequest()
            let sortDescriptor = NSSortDescriptor(keyPath: \Category.name, ascending: true)
            request.sortDescriptors = [sortDescriptor]
            
            do {
                self.categories = try viewContext.fetch(request)
            } catch {
                print("Error fetching categories: \(error)")
            }
        }
        
        
        // Ajouter une catégorie
        mutating func addCategory(uuid: UUID, name: String) {
            guard !name.isEmpty else {
                print("Tous les champs obligatoires doivent être remplis.")
                return
            }
            
            if categories.first(where: { $0.name == name }) != nil {
                print("La catégorie existe déjà")
                return
            }
            
            let newCategory = Category(context: viewContext)
            newCategory.uuid = uuid
            newCategory.name = name
            
            saveContext()
        }
        
        private func saveContext() {
            do {
                if viewContext.hasChanges {
                    try viewContext.save()
                }
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // Initialisation des sous-modèles
    var itemManager: ItemManager
    var categoryManager: CategoryManager
    var itemFilterManager: ItemFilterManager
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        self.itemManager = ItemManager(items: [], viewContext: viewContext, itemFilter: ItemFilterManager())
        self.categoryManager = CategoryManager(categories: [], viewContext: viewContext)
        self.itemFilterManager = ItemFilterManager()
        
        // Initialiser les données
        fetchItems()
        fetchCategories()
        extractCategories()
    }
    
    // Méthodes d'appel des sous-modèles
    func fetchItems() {
        itemManager.fetchItems()
        extractCategories()
        filterItems()
    }

    
    func fetchCategories() {
        categoryManager.fetchCategories()
    }
    
    func extractCategories() {
        // Extraire les catégories uniques en récupérant uniquement le nom
        let allCategories = Set(itemManager.items.compactMap { $0.category?.name })
        itemsCategories = Array(allCategories).sorted()
    }
    
    // Filtrage des items par catégorie
    func filterItems() {
        itemFilterManager.updateFilteredItems(allItems: itemManager.items)
        filteredItems = itemFilterManager.filteredItems
    }
    
    // Mettre à jour la sélection des catégories
    func toggleCategorySelection(category: String) {
        itemFilterManager.toggleCategorySelection(category: category)
        filterItems()
    }
    
    // Ajouter un item
    func addItem(name: String, color: String, size: String, brand: String, category: Category?, imageData: Data?) {
        let UUID = UUID()
        itemManager.addItem(uuid: UUID, name: name, color: color, size: size, brand: brand, category: category, imageData: imageData)
        fetchItems()
    }
    
    // Ajouter une catégorie
    func addCategory(name: String) {
        let uuid = UUID()
        categoryManager.addCategory(uuid: uuid, name: name)
        fetchCategories()
    }
    
    func deleteItem(item: Item) {
        itemManager.deleteItem(item: item)
        fetchItems()
    }
}




