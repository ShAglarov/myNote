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









