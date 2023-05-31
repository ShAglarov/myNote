//
//  NoteTableViewCell.swift
//  StudySnapKit
//
//  Created by Shamil Aglarov on 29.05.2023.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
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
    
    //MARK: - Button and Label Customization
    
    var isCompleteBtn = UIButton()
    var titleLbl = UILabel()
    var dateLbl = UILabel()
    //MARK: - InitStyle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cell")
        
        
        setupConfigureConstraints()
        
        isCompleteBtn.addTarget(self, action: #selector(tapCheckMark), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var delegate: NoteTableViewCellDelegate?
    
    @objc func tapCheckMark() {
        delegate?.checkMarkTapped(sender: self)
    }
}

extension NoteTableViewCell {
    
    func setupConfigureConstraints() {
        
        contentView.addSubview(isCompleteBtn)
        contentView.addSubview(titleLbl)
        contentView.addSubview(dateLbl)
        
        isCompleteBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(8)
            make.top.centerY.equalTo(contentView)
            make.width.height.equalTo(30)
        }
        
        titleLbl.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp.centerX)
            make.centerY.equalTo(contentView.snp.centerY)
        }

        dateLbl.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView.snp.trailing).offset(-10)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
}
