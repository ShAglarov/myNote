//
//  ViewModel.swift
//  StudySnapKit
//
//  Created by Shamil Aglarov on 04.06.2023.
//

import Foundation

class NoteViewModel: ObservableObject, Identifiable {
    
    @Published var note: Note?
    
    init(note: Note?) {
        self.note = note
    }
}
