//
//  AddNoteViewController.swift
//  StudySnapKit
//
//  Created by Shamil Aglarov on 09.06.2023.
//

import UIKit

class AddNoteViewController: UIViewController {
    
    //MARK: - interface declaration
    
    var noteListViewModel: NoteListViewModel?
    private var menuView: UIView!
    private var dateMenu: UIView!
    private var titleTF: UITextField!
    private var selectDateLbl: UILabel!
    private var isCompleteBtn: UIButton!
    private var dueDatePicker: UIDatePicker!
    private var notesTV: UITextView!

    
    //MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                           target: self,
                                                           action: #selector(backMenu)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(saveBtnTarget))
        
        setupConfigureConstraints()
    }
}

//MARK: - Interface сustomization

extension AddNoteViewController {
    
    @objc func saveBtnTarget() {
        guard let noteListViewModel = noteListViewModel else { return }
        
        let newNote = Note(title: titleTF.text,
                           isComplete: true,
                           dueDate: dueDatePicker.date,
                           notes: notesTV.text)
        
        noteListViewModel.addNewNote(newNote)
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func backMenu() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setupConfigureConstraints() {
        menuView = {
            let headerLbl = UILabel()
            headerLbl.text = "Заголовок"
            headerLbl.textAlignment = .left
            headerLbl.textColor = .lightGray
            view.addSubview(headerLbl)
            
            let menu = UIView()
            menu.layer.borderWidth = 0.5
            menu.layer.borderColor = UIColor.gray.cgColor
            view.addSubview(menu)
            
            menu.snp.makeConstraints { (make) in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(25)
                make.left.right.equalTo(view.safeAreaLayoutGuide)
                make.height.equalTo(40)
            }
            headerLbl.snp.makeConstraints { (make) in
                make.bottom.equalTo(menu.snp.top)
                make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(10)
            }
            
            return menu
        }()
        
        dateMenu = {
            let headerLeftLbl = UILabel()
            headerLeftLbl.text = "Выберите дату и время напоминания"
            headerLeftLbl.textColor = .black
            view.addSubview(headerLeftLbl)
            
            let menu = UIView()
            menu.layer.borderWidth = 0.5
            menu.layer.borderColor = UIColor.gray.cgColor
            view.addSubview(menu)
            
            menu.snp.makeConstraints { (make) in
                make.top.equalTo(menuView.snp.bottom).offset(20)
                make.left.right.equalTo(view.safeAreaLayoutGuide)
                make.height.equalTo(40)
            }
            
            headerLeftLbl.snp.makeConstraints { (make) in
                make.centerX.centerY.equalTo(menu)
            }
            
            return menu
        }()
        
        isCompleteBtn = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "circle"), for: .normal)
            menuView.addSubview(button)
            
            button.snp.makeConstraints { (make) in
                make.leading.equalTo(menuView.snp.leading).offset(8)
                make.centerY.equalTo(menuView)
                make.width.height.equalTo(30)
            }
            
            return button
        }()
        
        titleTF = {
            let textField = UITextField()
            textField.placeholder = "Введите заголовок"
            menuView.addSubview(textField)
            
            textField.snp.makeConstraints { (make) in
                make.centerY.equalTo(menuView)
                make.left.equalTo(isCompleteBtn.snp.right).offset(8)
                make.right.equalTo(view.snp.right).offset(-8)
            }
            
            return textField
        }()
        
        dueDatePicker = {
            let date = UIDatePicker()
            date.preferredDatePickerStyle = .wheels
            date.minimumDate = Date()
            view.addSubview(date)
            
            date.snp.makeConstraints { (make) in
                make.top.equalTo(dateMenu.snp.bottom)
                make.centerX.equalTo(view)
            }
            
            return date
        }()
        
        notesTV = {
            let textView = UITextView()
            textView.layer.borderWidth = 0.5
            textView.layer.borderColor = UIColor.black.cgColor
            textView.layer.cornerRadius = 10.0
            view.addSubview(textView)
            
            textView.snp.makeConstraints { (make) in
                make.top.equalTo(dueDatePicker.snp.bottom).offset(8)
                make.left.equalTo(view.snp.left).offset(8)
                make.right.equalTo(view.snp.right).offset(-8)
                make.bottom.equalTo(view.snp.bottom).offset(-23)
            }
            
            return textView
        }()
    }
}
