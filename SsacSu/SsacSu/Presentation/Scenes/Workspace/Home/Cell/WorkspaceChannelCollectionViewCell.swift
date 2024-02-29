//
//  WorkspaceChannelCollectionViewCell.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/27.
//

import UIKit

class WorkspaceChannelCollectionViewCell: BaseCollectionViewCell {
    
    enum CellType {
        case plain
        case unread
    }
    
    let hashtagImage = UIImageView(image: .hashtagThin)
    
    let channelTitle = {
        let lbl = UILabel()
        lbl.textColor = .Text.secondary
        lbl.font = SSFont.style(.body)
        return lbl
    }()
    
    let unreadCountLabel = {
        let lbl = UnreadLabel()
        lbl.text = "7"
        return lbl
    }()
    
    override func configureCell() {
        [hashtagImage, channelTitle, unreadCountLabel].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        hashtagImage.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(16)
            make.centerY.equalTo(contentView)
            make.size.equalTo(18)
        }
        
        channelTitle.snp.makeConstraints { make in
            make.leading.equalTo(hashtagImage.snp.trailing).offset(16)
            make.centerY.equalTo(hashtagImage)
        }
        
        unreadCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(16)
            make.centerY.equalTo(hashtagImage)
        }
    }
    
}

extension WorkspaceChannelCollectionViewCell {
    
    func bind(item: Channel, _ unreadCount: Int) {
        channelTitle.text = item.name
        unreadCountLabel.text = "\(unreadCount)"
    }
    
    func style(_ cellType: CellType) {
        switch cellType {
        case .plain: plain()
        case .unread: unread()
        }
    }
    
}

extension WorkspaceChannelCollectionViewCell {
    
    func plain() {
        hashtagImage.image = .hashtagThin
        
        channelTitle.font = SSFont.style(.body)
        channelTitle.textColor = .Text.secondary
        
        unreadCountLabel.isHidden = true
    }
    
    func unread() {
        hashtagImage.image = .hashtagThick
        
        channelTitle.font = SSFont.style(.bodyBold)
        channelTitle.textColor = .Text.primary
        
        unreadCountLabel.isHidden = false
    }
    
}
