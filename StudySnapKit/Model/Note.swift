//
//  NoteList.swift
//  StudySnapKit
//
//  Created by Shamil Aglarov on 29.05.2023.
//

import Foundation

struct Note: Codable, Identifiable, Equatable {
    
    var id = UUID()
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    init(title: String?,
             isComplete: Bool,
             dueDate: Date,
             notes: String?)
        {
            self.id = UUID()
            self.title = title ?? ""
            self.isComplete = isComplete
            self.dueDate = dueDate
            self.notes = notes
        }
    
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.id == rhs.id
    }
}
