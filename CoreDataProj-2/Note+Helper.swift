//
//  Note+Helper.swift
//  CoreDataProj-2
//
//  Created by Praveen V on 24/06/26.
//

import Foundation

extension Note {
    var wrappedTitle: String { title ?? "Untitled" }
    var wrappedContent: String { content ?? "" }
    var wrappedCategory: String { category ?? "General" }
}

enum NoteCategory: String, CaseIterable, Identifiable {
    case work = "Work"
    case personal = "Personal"
    case ideas = "Ideas"
    case general = "General"

    var id: String { rawValue }
}

