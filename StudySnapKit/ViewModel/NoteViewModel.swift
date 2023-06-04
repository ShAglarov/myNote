//
//  ViewModel.swift
//  StudySnapKit
//
//  Created by Shamil Aglarov on 04.06.2023.
//

import Foundation

class NoteViewModel: ObservableObject {
    
    @Published var notes = [Note]()
    private let noteService: NoteService
    
    init(noteService: NoteService = NoteService()) {
        self.noteService = noteService
    }
    
    func loadNotes() {
        notes = noteService.loadNotes() ?? []
    }
    
    func saveNotes() {
        noteService.saveNotes(notes: notes)
    }
}

// This is the service class that handles data persistence
class NoteService {
    
    private let documentDirectory = FileManager
        .default
        .urls(for: .documentDirectory, in: .userDomainMask).first!
    
    private var archiveURL: URL {
        documentDirectory.appendingPathComponent("q").appendingPathExtension("plist")
    }
    
    func loadNotes() -> [Note]? {
        guard let dataContent = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Note>.self, from: dataContent)
    }
    
    func saveNotes(notes: [Note]) {
        let propertyListEncode = PropertyListEncoder()
        let encodedList = try? propertyListEncode.encode(notes)
        try? encodedList?.write(to: archiveURL, options: .noFileProtection)
    }
}







