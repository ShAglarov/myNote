//
//  ViewController.swift
//  StudySnapKit
//
//  Created by Shamil Aglarov on 29.05.2023.
//

import UIKit
import SnapKit

protocol NoteTableViewCellDelegate {
    func checkMarkTapped(sender: UITableViewCell)
}

class NoteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var noteListViewModel = NoteListViewModel()
    var selectedIndex = Int()
    
    let tableView: UITableView = {
        let table = UITableView()
        
        table.register(NoteTableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    
    //MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Напоминание"
        
        
        
        navigationItem.leftBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .edit,
                        target: self,
                        action: #selector(editButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        noteListViewModel.updateNotes()
    }
    
    @objc func editButtonTapped() {
        //Проверяем была ли отмечена хотя бы одна заметка
        guard noteListViewModel.isAnyNoteMarked() else {
           // иначе вызываем сообщение пользователю
           return showNoSelectionAlert()
        }
        
        let editNoteViewController = EditNoteViewController()
        
        editNoteViewController.noteListViewModel = self.noteListViewModel
        editNoteViewController.selectedIndex = self.selectedIndex
        
        navigationController?.pushViewController(editNoteViewController, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteListViewModel.noteViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? NoteTableViewCell else {
            return UITableViewCell()
        }
        // сохраняем данные каждой ячейки
        guard let noteViewModel = noteListViewModel.noteViewModels[indexPath.row].note else { return UITableViewCell() }
        
        // Форма даты
        let textDate = noteListViewModel.formatter(noteViewModel.dueDate)
        
        cell.dateLbl.text = textDate
        cell.titleLbl.text = noteViewModel.title
        cell.isComplete = noteViewModel.isComplete
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let noteItem = noteListViewModel.noteViewModels[indexPath.row].note else { return }
        
        // при нажатии на ячейку пушим AlertViewController с подробной инфой о заметке
        showDidSelect(note: noteItem)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // удаляем ячейку из базы
            noteListViewModel.removeNoteFromLists(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension NoteViewController: NoteTableViewCellDelegate {
    
    /// проверяем
    func checkMarkTapped(sender: UITableViewCell) {
        
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        noteListViewModel.checkMarkTapped(at: indexPath.row)
        self.selectedIndex = indexPath.row
        tableView.reloadData()
    }
}

// MARK: - AlertControllers

extension NoteViewController {
    
    /// если ни одна ячейка не выбрана, то выдаем предупреждение
    func showNoSelectionAlert() {
        
        let alertController = UIAlertController(title: "Заметка не выбрана", message: "Какую заметку желаете редактировать?", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Закрыть", style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
        
    /// при нажатии на ячейку пушим AlertViewController с подробной инфой о заметке
    func showDidSelect(note: Note) {
        
        let alertController = UIAlertController(title: note.title,
                                                message: note.notes,
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Закрыть", style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
}
