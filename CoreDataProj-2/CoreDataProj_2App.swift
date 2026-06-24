//
//  CoreDataProj_2App.swift
//  CoreDataProj-2
//
//  Created by Praveen V on 23/06/26.
//

import SwiftUI
internal import CoreData

@main
struct NotesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NoteListView(viewModel: NotesViewModel(context: PersistenceController.preview.container.viewContext))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
