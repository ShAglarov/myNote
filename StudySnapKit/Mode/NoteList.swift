//
//  NoteList.swift
//  StudySnapKit
//
//  Created by Shamil Aglarov on 29.05.2023.
//

import Foundation

struct NoteList: Codable, Equatable {
    
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
    
    static func == (lhs: NoteList, rhs: NoteList) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func loadSimpleNote() -> [NoteList] {
        let simpleNote = NoteList(title: "Первоначальная цель",
                                  isComplete: false,
                                  dueDate: Date(),
                                  notes: "Выполнить все поставленные задачи")
        let simpleNoteTwo = NoteList(title: "Вторая цель",
                                  isComplete: false,
                                  dueDate: Date(),
                                  notes: "Проверить все ли выполнено")
        return [simpleNote, simpleNoteTwo]
    }
    
    static let documentDirectory = FileManager
        .default
        .urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let archiveURL = documentDirectory.appendingPathComponent("q")
        .appendingPathExtension("plist")
    
    static func loadDataContent() -> [NoteList]? {
        
        guard let dataContent = try? Data(contentsOf: archiveURL) else { return nil }
        
        let propertyListDecoder = PropertyListDecoder()
                
        return try? propertyListDecoder.decode(Array<NoteList>.self, from: dataContent)
    }
    
    static func saveData(noteListArray: [NoteList]) {
        
        let propertyListEncode = PropertyListEncoder()
        
        let encodedList = try? propertyListEncode.encode(noteListArray)
        
        try? encodedList?.write(to: archiveURL, options: .noFileProtection)
    }
}
