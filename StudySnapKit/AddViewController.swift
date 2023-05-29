//
//  AddViewController.swift
//  StudySnapKit
//
//  Created by Shamil Aglarov on 30.05.2023.
//

import UIKit

class AddViewController: UIViewController {
    
    var toNoteList: NoteList?
    
    //MARK: - interface declaration
    
    var menuView: UIView!
    var dateMenu: UIView!
    var titleTF: UITextField!
    var selectDateLbl: UILabel!
    var isCompleteBtn: UIButton!
    var dueDatePicker: UIDatePicker!
    var notesTV: UITextView!
    
    @objc func saveBtnTarget() {
        print("save")
    }
    //MARK: - Setting state image, for button isCompleteBtn
    
    var isComplete = false {
        didSet {
            if isComplete {
                isCompleteBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            } else {
                isCompleteBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            }
        }
    }
    
    func formatter(_ date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        
        return formatter.string(from: date)
    }
    
    //MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let saveBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveBtnTarget))
        
        navigationItem.rightBarButtonItem = saveBtn
        
        setupConfigureConstraints()
    }
}

//MARK: - Interface сustomization

extension AddViewController {
    
    func setupConfigureConstraints() {
        
        menuView = {
            let headerLbl = UILabel()
                headerLbl.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(headerLbl)
                headerLbl.text = "Заголовок"
                headerLbl.textAlignment = .left
                headerLbl.textColor = .lightGray
            
            let menu = UIView()
            
            menu.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(menu)
            menu.layer.borderWidth = 0.5
            menu.layer.borderColor = UIColor.gray.cgColor
            
            NSLayoutConstraint.activate([
                menu.topAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
                menu.leftAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                menu.rightAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                menu.heightAnchor
                    .constraint(equalToConstant: 40),
                
                headerLbl.bottomAnchor.constraint(equalTo: menu.topAnchor, constant: 0),
                headerLbl.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                            constant: 10)
            ])
            
            return menu
        }()
        
        dateMenu = {
            
            let headerLeftLbl = UILabel()
            headerLeftLbl.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(headerLeftLbl)
            headerLeftLbl.text = "Выберите дату и время напоминания"
            headerLeftLbl.textColor = .black
            
            let menu = UIView()
            
            menu.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(menu)
            menu.layer.borderWidth = 0.5
            menu.layer.borderColor = UIColor.gray.cgColor
            
            NSLayoutConstraint.activate([
                menu.topAnchor
                    .constraint(equalTo: menuView.bottomAnchor, constant: 20),
                menu.leftAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                menu.rightAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                menu.heightAnchor
                    .constraint(equalToConstant: 40),
                
                headerLeftLbl.centerXAnchor.constraint(equalTo: menu.centerXAnchor),
                headerLeftLbl.centerYAnchor.constraint(equalTo: menu.centerYAnchor)
            ])
            
            return menu
        }()
        
        isCompleteBtn = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            menuView.addSubview(button)
            button.setImage(UIImage(systemName: "circle"), for: .normal)
            
            NSLayoutConstraint.activate([
                button.leadingAnchor
                    .constraint(equalTo: menuView.leadingAnchor, constant: 8),
                button.centerYAnchor
                    .constraint(equalTo: menuView.centerYAnchor),
                button.widthAnchor
                    .constraint(equalToConstant: 30),
                button.heightAnchor
                    .constraint(equalToConstant: 30)
            ])
            return button
        }()
        
        titleTF = {
                    let textField = UITextField()
                    textField.translatesAutoresizingMaskIntoConstraints = false
                    textField.placeholder = "Введите заголовок"
                    menuView.addSubview(textField)
                    NSLayoutConstraint.activate([
                        textField.centerYAnchor.constraint(equalTo: menuView.centerYAnchor),
                        textField.leftAnchor.constraint(equalTo: isCompleteBtn.rightAnchor, constant: 8),
                        textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
                    ])
                    return textField
                }()
        
        dueDatePicker = {
            let date = UIDatePicker()
            date.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(date)
            
            date.preferredDatePickerStyle = .wheels
            date.minimumDate = Date()
            
            NSLayoutConstraint.activate([
                date.topAnchor.constraint(equalTo: dateMenu.bottomAnchor),
                date.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            return date
        }()
        
        notesTV = {
            let textView = UITextView()
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.layer.borderWidth = 0.5
            textView.layer.borderColor = UIColor.black.cgColor
            textView.layer.cornerRadius = 10.0
            
            self.view.addSubview(textView)
            NSLayoutConstraint.activate([
                textView.topAnchor.constraint(equalTo: dueDatePicker.bottomAnchor, constant: 8),
                textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
                textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
                textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -23),
            ])
            return textView
        }()
    }
}
