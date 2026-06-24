//
//  NoteRowView.swift
//  CoreDataProj-2
//
//  Created by Praveen V on 24/06/26.
//

import SwiftUI
internal import CoreData

struct NoteRowView: View {
    @ObservedObject var note: Note
    @ObservedObject var viewModel: NotesViewModel

    @State private var isEditing = false
    @State private var editedTitle = ""
    @State private var editedContent = ""
    @State private var editedCategory = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if isEditing {
                editingFields
            } else {
                displayFields
            }
        }
        .padding(.vertical, 6)
    }

    private var displayFields: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(note.wrappedTitle)
                    .font(.headline)
                Spacer()
                Text(note.wrappedCategory)
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.accentColor.opacity(0.15))
                    .foregroundStyle(Color.accentColor)
                    .clipShape(Capsule())
            }
            Text(note.wrappedContent)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            if let date = note.modifiedAt {
                Text("Modified \(date.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            HStack {
                Button {
                    startEditing()
                } label: {
                    Label("Edit", systemImage: "pencil")
                        .font(.caption)
                }
                .buttonStyle(.bordered)

                Button(role: .destructive) {
                    viewModel.deleteNote(note)
                } label: {
                    Label("Delete", systemImage: "trash")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
            }
            .padding(.top, 4)
        }
    }

    private var editingFields: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("Title", text: $editedTitle)
                .textFieldStyle(.roundedBorder)
                .font(.headline)

            Picker("Category", selection: $editedCategory) {
                ForEach(NoteCategory.allCases) { cat in
                    Text(cat.rawValue).tag(cat.rawValue)
                }
            }
            .pickerStyle(.segmented)

            TextEditor(text: $editedContent)
                .frame(minHeight: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )

            HStack {
                Button("Cancel", role: .cancel) {
                    isEditing = false
                }
                .buttonStyle(.bordered)

                Spacer()

                Button("Save") {
                    saveChanges()
                }
                .buttonStyle(.borderedProminent)
                .disabled(editedTitle.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }

    private func startEditing() {
        editedTitle = note.wrappedTitle
        editedContent = note.wrappedContent
        editedCategory = note.wrappedCategory
        isEditing = true
    }

    private func saveChanges() {
        viewModel.updateNote(note, title: editedTitle, content: editedContent, category: editedCategory)
        isEditing = false
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let viewModel = NotesViewModel(context: context)
    let sampleNote = viewModel.notes.first ?? Note(context: context)

    return List {
        NoteRowView(note: sampleNote, viewModel: viewModel)
    }
}
