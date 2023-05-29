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
    
        let tableView: UITableView = {
            let table = UITableView()
            
            table.register(NoteTableViewCell.self, forCellReuseIdentifier: "cell")
            
            table.translatesAutoresizingMaskIntoConstraints = false
            return table
        }()
    
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
        navigationItem.title = "Home"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        navigationItem.leftBarButtonItem = self.editButtonItem
        
        if let savedToNotes = NoteList.loadDataContent() {
            noteLists += savedToNotes
        } else {
            noteLists += NoteList.loadSimpleNote()
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
        cell.dateLbl.text = dateFormatter.string(from: Date())
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
            
            noteLists[indexPath.row].isComplete.toggle()
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
            NoteList.saveData(noteListArray: noteLists)
        }
    }
}
