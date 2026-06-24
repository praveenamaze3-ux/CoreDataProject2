//
//  AddNoteView.swift
//  CoreDataProj-2
//
//  Created by Praveen V on 24/06/26.
//

import SwiftUI
internal import CoreData

struct AddNoteView: View {
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var content = ""
    @State private var category = NoteCategory.general.rawValue

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Note title", text: $title)
                }
                Section("Category") {
                    Picker("Category", selection: $category) {
                        ForEach(NoteCategory.allCases) { cat in
                            Text(cat.rawValue).tag(cat.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section("Content") {
                    TextEditor(text: $content)
                        .frame(minHeight: 150)
                }
            }
            .navigationTitle("New Note")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.addNote(title: title, content: content, category: category)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddNoteView(viewModel: NotesViewModel(context: PersistenceController.preview.container.viewContext))
}
