//
//  NoteListView.swift
//  CoreDataProj-2
//
//  Created by Praveen V on 24/06/26.
//

import SwiftUI
internal import CoreData

struct NoteListView: View {
    @StateObject var viewModel: NotesViewModel
    @State private var showingAddNote = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                categoryFilterBar
                sortMenu

                List {
                    ForEach(viewModel.notes) { note in
                        NoteRowView(note: note, viewModel: viewModel)
                    }
                    .onDelete(perform: viewModel.deleteNotes)
                }
                .listStyle(.plain)
                .overlay {
                    if viewModel.notes.isEmpty {
                        ContentUnavailableView(
                            "No Notes",
                            systemImage: "note.text",
                            description: Text(viewModel.searchText.isEmpty
                                ? "Tap + to add your first note."
                                : "No notes match your search.")
                        )
                    }
                }
            }
            .navigationTitle("Notes")
            .searchable(text: $viewModel.searchText, prompt: "Search notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddNote = true
                    } label: {
                        Label("Add Note", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddNote) {
                AddNoteView(viewModel: viewModel)
            }
        }
    }

    private var categoryFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.availableCategories, id: \.self) { category in
                    Button {
                        viewModel.selectedCategory = category
                    } label: {
                        Text(category)
                            .font(.subheadline)
                            .fontWeight(viewModel.selectedCategory == category ? .semibold : .regular)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(viewModel.selectedCategory == category
                                          ? Color.accentColor
                                          : Color.gray.opacity(0.2))
                            )
                            .foregroundStyle(viewModel.selectedCategory == category ? .white : .primary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }

    private var sortMenu: some View {
        HStack {
            Spacer()
            Menu {
                ForEach(NotesViewModel.SortOption.allCases) { option in
                    Button {
                        viewModel.sortOption = option
                    } label: {
                        if viewModel.sortOption == option {
                            Label(option.rawValue, systemImage: "checkmark")
                        } else {
                            Text(option.rawValue)
                        }
                    }
                }
            } label: {
                Label("Sort: \(viewModel.sortOption.rawValue)", systemImage: "arrow.up.arrow.down")
                    .font(.caption)
            }
            .padding(.horizontal)
            .padding(.bottom, 6)
        }
    }
}

#Preview {
    NoteListView(viewModel: NotesViewModel(context: PersistenceController.preview.container.viewContext))
}
