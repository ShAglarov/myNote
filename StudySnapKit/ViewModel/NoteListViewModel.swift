//
//  NoteListViewModel.swift
//  StudySnapKit
//
//  Created by Shamil Aglarov on 05.06.2023.
//

import Foundation

class NoteListViewModel: ObservableObject {
    
    @Published var noteViewModels = [NoteViewModel]()
    
    private let noteService: NoteService
    
    init(noteService: NoteService = NoteService()) {
        self.noteService = noteService
    }
    
    /// Функция для обновления данных из базы
    func updateNotes() {
        do {
            noteViewModels = try noteService.loadDataContent()
        } catch NoteService.NoteServiceError.fileReadError {
            print("Ошибка чтения файла")
        } catch {
            print("Непредвиденная ошибка: \(error).")
        }
    }
    
    /// Редактируем определенную ячейку, и помещаем в него новое значение
    func editNotes(note: Note, id: String) {
        if let index = noteViewModels
            .firstIndex(where: { $0.note?.id.uuidString == id }) {
            noteViewModels[index].note = note
            saveNotes()
        }
    }
    
    /// Функция для сохранения данных в базу
    func saveNotes() {
        do {
            try noteService.saveData(noteViewModels: noteViewModels)
        } catch NoteService.NoteServiceError.fileWriteError {
            print("Ошибка записи в файл")
        } catch {
            print("Непредвиденная ошибка: \(error).")
        }
    }
    
    /// Функция для добавления новой заметки
    func addNewNote(_ note: Note) {
        // создаем новую модель заметки
        let noteViewModel = NoteViewModel(note: note)
        // добавляем заметку
        noteViewModels.append(noteViewModel)
        // сохраняем заметку в базе
        saveNotes()
    }
    
    func removeNoteFromLists(at index: Int) {
        noteViewModels.remove(at: index)
        saveNotes()
    }
    
    // Проверяем была ли отмечена хотя бы одна заметка, и возвращает индекс первой отмеченной заметки
    func checkSelectedRows() -> (Int?, Bool?) {
        var indexSelectedNote: Int?
        var isAnyNoteChecked: Bool?

        // Проверяем, какие заметки были отмечены
        for (index, noteViewModel) in noteViewModels.enumerated() {
            if noteViewModel.note?.isComplete ?? false {
                indexSelectedNote = index
                isAnyNoteChecked = noteViewModel.note?.isComplete
            }
        }
        return (indexSelectedNote, isAnyNoteChecked)
    }
    
    /// Проверяем была ли отмечена хотя бы одна заметка
    func isAnyNoteMarked() -> Bool {

        var isAnyNoteChecked: Bool?
        
        // Проверяем, какие заметки были отмечены
        for noteViewModel in noteViewModels.enumerated() {
            if noteViewModel.element.note?.isComplete ?? false {
                isAnyNoteChecked = noteViewModel.element.note?.isComplete
            }
        }
        return isAnyNoteChecked ?? false
    }
    /// по нажатию на ячейку, проверяем была ли активна другая ячейка, да то снимаем предыдущую отметку и стави отметку на новую выбранную ячейку
    func checkMarkTapped(at index: Int) {
        // Если выбранная ячейка уже отмечена, снимаем отметку
        if noteViewModels[index].note?.isComplete ?? false {
            noteViewModels[index].note?.isComplete = false
        } else {
            // Иначе, снимаем отметку со всех других ячеек
            for (index, _) in noteViewModels.enumerated() {
                noteViewModels[index].note?.isComplete = false
            }
            
            // устанавливаем отметку для выбранной ячейки
            noteViewModels[index].note?.isComplete = true
            // преобразуем note.id в строку
            let selectedNoteID = noteViewModels[index].note?.id.uuidString
            //Сохраняем уникальный идентификатор послейдней выбранной ячейки indexPath
            UserDefaults.standard.set(selectedNoteID, forKey: "selectedNoteID")
        }
        saveNotes()
    }
    
    /// форматируем  дату в строку формата "день.месяц.год"
    func formatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    func printBase() {
        print(noteViewModels.map { $0.note?.isComplete})
    }
}
