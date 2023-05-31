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

//MARK: - Class ViewController

class NoteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var noteLists = [NoteList]()
    var indexPathSelectedRow: IndexPath?
    
    var isAnyCellChecked: Bool?
    
    let tableView: UITableView = {
        let table = UITableView()
        
        table.register(NoteTableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var didRegister: (NoteList) -> () = { _ in}
    
    func didSelect(note: NoteList) {
        
        let alertController = UIAlertController(title: note.title,
                                                message: note.notes,
                                                preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Закрыть", style: .default)
        alertController.addAction(alertAction)
        
        present(alertController, animated: true)
    }
    
    //MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        navigationItem.title = "Напоминание"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit,
                                         target: self,
                                         action: #selector(editButtonTapped)
        )
        
        navigationItem.leftBarButtonItem = editButton
        
        if let savedToNotes = NoteList.loadDataContent() {
            noteLists += savedToNotes
        } else {
            noteLists += NoteList.loadSimpleNote()
        }
        
        // Проверяем, какие ячейки были отмечены
        for (index, note) in noteLists.enumerated() {
            if note.isComplete {
                indexPathSelectedRow = IndexPath(row: index, section: 0)
                isAnyCellChecked = note.isComplete
            }
        }
    }
    
    
    
    @objc func editButtonTapped() {
        let addVC = AddViewController()
        addVC.sendNoteDelegate = self
        
        // если при нажатии кнопки Edit хотя бы один флажок включен,
        //то переходим в режим редактирования этой ячейки
        if noteLists.contains(where: { $0.isComplete }) {
            //didRegister(noteLists[indexPathSelectedRow?.row ?? 10])
            addVC.note = noteLists[indexPathSelectedRow?.row ?? 10]
            navigationController?.pushViewController(addVC, animated: true)
        }
    }
    
    //MARK: - viewDidLayoutSubviews()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func formatter(_ date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        
        return formatter.string(from: date)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? NoteTableViewCell else { return UITableViewCell() }
        
        let note = noteLists[indexPath.row]
        
        //Configure cell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd:MM:YYYY"
        
        cell.isComplete = note.isComplete
        cell.titleLbl.text = note.title
        cell.dateLbl.text = formatter(noteLists[indexPath.row].dueDate)
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let noteItem = noteLists[indexPath.row]
        
        didSelect(note: noteItem)
    }
}

extension NoteViewController: NoteTableViewCellDelegate {
    
    func checkMarkTapped(sender: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            
            // Если ячейка уже отмечена или нет других отмеченных ячеек
            if noteLists[indexPath.row].isComplete || !(isAnyCellChecked ?? false) {
                noteLists[indexPath.row].isComplete.toggle()
                indexPathSelectedRow = indexPath
            }
            
            // Обновить флаг, если хотя бы одна ячейка отмечена то isAnyCellChecked = true
            isAnyCellChecked = noteLists.contains { $0.isComplete }
            print(indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            NoteList.saveData(noteListArray: noteLists)
        }
    }
}

extension NoteViewController: AddViewControllerDelegate {
    func noteUpdated(note: NoteList) {
        // Находим соответствующую ячейку и обновляем ее
        
        guard let indexPath = indexPathSelectedRow else {
            return
        }
        
        noteLists[indexPath.row] = note
        tableView.reloadData()
        NoteList.saveData(noteListArray: noteLists)
    }
}

