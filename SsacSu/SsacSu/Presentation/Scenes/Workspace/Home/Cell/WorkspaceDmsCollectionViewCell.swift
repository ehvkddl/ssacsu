//
//  WorkspaceDmsCollectionViewCell.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/28.
//

import UIKit

class WorkspaceDmsCollectionViewCell: BaseCollectionViewCell {
    
    enum CellType {
        case plain
        case unread
    }
    
    let profileImage = {
        let view = UIImageView()
        view.image = UIImage(resource: .Profile.noPhotoA)
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    let userNameLabel = {
        let lbl = UILabel()
        lbl.text = "닉네임"
        lbl.textColor = .Text.secondary
        lbl.font = SSFont.style(.body)
        return lbl
    }()
    
    let unreadCountLabel = {
        let lbl = UnreadLabel()
        lbl.text = "18"
        return lbl
    }()
    
    override func configureCell() {
        [profileImage, userNameLabel, unreadCountLabel].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        profileImage.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(14)
            make.centerY.equalTo(contentView)
            make.size.equalTo(24)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(11)
            make.centerY.equalTo(profileImage)
        }
        
        unreadCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(16)
            make.centerY.equalTo(profileImage)
        }
    }
    
}

extension WorkspaceDmsCollectionViewCell {
    
    func bind(item: DMsRoom, _ unreadCount: Int) {
        if let profileImageUrl = item.user.profileImage {
            let size = CGSize(width: 24, height: 24)
            profileImage.loadImage(url: profileImageUrl, size: size)
        } else {
            profileImage.image = UIImage(resource: .Profile.noPhotoC)
        }
        
        userNameLabel.text = item.user.nickname
        unreadCountLabel.text = "\(unreadCount)"
    }
    
    func style(_ cellType: CellType) {
        switch cellType {
        case .plain: plain()
        case .unread: unread()
        }
    }
    
}

extension WorkspaceDmsCollectionViewCell {
    
    func plain() {
        userNameLabel.font = SSFont.style(.body)
        unreadCountLabel.isHidden = true
    }
    
    func unread() {
        userNameLabel.font = SSFont.style(.bodyBold)
        unreadCountLabel.isHidden = false
    }
    
}
