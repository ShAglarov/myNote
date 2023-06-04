//
//  NoteService.swift
//  StudySnapKit
//
//  Created by Shamil Aglarov on 04.06.2023.
//

import Foundation

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
