//
//  Persistence.swift
//  CoreDataProj-2
//
//  Created by Praveen V on 23/06/26.
//

internal import CoreData

struct PersistenceController {
    nonisolated static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Notes")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    static var preview: PersistenceController = {
            let controller = PersistenceController(inMemory: true)
            let context = controller.container.viewContext

            let sampleCategories = ["Work", "Personal", "Ideas"]
            for i in 0..<5 {
                let note = Note(context: context)
                note.id = UUID()
                note.title = "Sample Note \(i + 1)"
                note.content = "This is sample content for note \(i + 1)."
                note.category = sampleCategories[i % sampleCategories.count]
                note.createdAt = Date().addingTimeInterval(Double(-i * 3600))
                note.modifiedAt = Date().addingTimeInterval(Double(-i * 1800))
            }

            try? context.save()
            return controller
    }()
}
