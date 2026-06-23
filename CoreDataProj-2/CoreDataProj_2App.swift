//
//  CoreDataProj_2App.swift
//  CoreDataProj-2
//
//  Created by Praveen V on 23/06/26.
//

import SwiftUI
import CoreData

@main
struct CoreDataProj_2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
