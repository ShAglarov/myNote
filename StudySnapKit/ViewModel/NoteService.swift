//
//  NoteService.swift
//  StudySnapKit
//
//  Created by Shamil Aglarov on 04.06.2023.
//

import Foundation

class NoteService {
    
    enum NoteServiceError: Error {
        case fileReadError
        case fileWriteError
    }
    
    private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    private var archiveURL: URL {
        return documentDirectory.appendingPathComponent("q").appendingPathExtension("plist")
    }
    
    func loadDataContent() throws -> [NoteViewModel] {
        guard let dataContent = try? Data(contentsOf: archiveURL) else {
            throw NoteServiceError.fileReadError
        }
        let propertyListDecoder = PropertyListDecoder()
        guard let notes = try? propertyListDecoder.decode(Array<Note>.self, from: dataContent) else {
            throw NoteServiceError.fileReadError
        }
        return notes.map(NoteViewModel.init(note:))
    }
    
    func saveData(noteViewModels: [NoteViewModel]) throws {
        let propertyListEncode = PropertyListEncoder()
        guard let encodedList = try? propertyListEncode.encode(noteViewModels.map { $0.note }) else {
            throw NoteServiceError.fileWriteError
        }
        do {
            try encodedList.write(to: archiveURL, options: .noFileProtection)
        } catch {
            throw NoteServiceError.fileWriteError
        }
    }
}
