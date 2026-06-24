//
//  NotesViewModel.swift
//  CoreDataProj-2
//
//  Created by Praveen V on 24/06/26.
//

import Foundation
internal import CoreData
import Combine

@MainActor
final class NotesViewModel: ObservableObject {

    @Published var notes: [Note] = []
    @Published var searchText: String = "" {
        didSet { applyFilters() }
    }
    @Published var selectedCategory: String = "All" {
        didSet { applyFilters() }
    }
    @Published var sortOption: SortOption = .modifiedDateDescending {
        didSet { fetchNotes() }
    }

    enum SortOption: String, CaseIterable, Identifiable {
        case modifiedDateDescending = "Last Modified"
        case createdDateDescending = "Date Created"
        case titleAscending = "Title (A–Z)"

        var id: String { rawValue }

        var sortDescriptor: NSSortDescriptor {
            switch self {
            case .modifiedDateDescending:
                return NSSortDescriptor(keyPath: \Note.modifiedAt, ascending: false)
            case .createdDateDescending:
                return NSSortDescriptor(keyPath: \Note.createdAt, ascending: false)
            case .titleAscending:
                return NSSortDescriptor(keyPath: \Note.title, ascending: true)
            }
        }
    }

    private let context: NSManagedObjectContext
    private var allNotes: [Note] = []

    var availableCategories: [String] {
        let categories = Set(allNotes.map { $0.wrappedCategory })
        return ["All"] + categories.sorted()
    }

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        fetchNotes()
    }

    // MARK: - Fetch (Read)

    func fetchNotes() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.sortDescriptors = [sortOption.sortDescriptor]

        do {
            allNotes = try context.fetch(request)
            applyFilters()
        } catch {
            print("Fetch error: \(error)")
            allNotes = []
            notes = []
        }
    }

    private func applyFilters() {
        notes = allNotes.filter { note in
            let matchesCategory = selectedCategory == "All" || note.wrappedCategory == selectedCategory
            let matchesSearch = searchText.isEmpty ||
                note.wrappedTitle.localizedCaseInsensitiveContains(searchText) ||
                note.wrappedContent.localizedCaseInsensitiveContains(searchText)
            return matchesCategory && matchesSearch
        }
    }

    // MARK: - Create

    func addNote(title: String, content: String, category: String) {
        let note = Note(context: context)
        note.id = UUID()
        note.title = title
        note.content = content
        note.category = category
        let now = Date()
        note.createdAt = now
        note.modifiedAt = now

        save()
        fetchNotes()
    }

    // MARK: - Update

    func updateNote(_ note: Note, title: String, content: String, category: String) {
        note.title = title
        note.content = content
        note.category = category
        note.modifiedAt = Date()

        save()
        fetchNotes()
    }

    // MARK: - Delete

    func deleteNotes(at offsets: IndexSet) {
        offsets.map { notes[$0] }.forEach(context.delete)
        save()
        fetchNotes()
    }

    func deleteNote(_ note: Note) {
        context.delete(note)
        save()
        fetchNotes()
    }

    // MARK: - Persistence

    private func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Save error: \(error)")
        }
    }
}
