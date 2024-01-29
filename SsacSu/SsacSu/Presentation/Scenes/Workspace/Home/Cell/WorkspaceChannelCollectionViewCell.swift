//
//  WorkspaceChannelCollectionViewCell.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/27.
//

import UIKit

class WorkspaceChannelCollectionViewCell: BaseCollectionViewCell {
    
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
    
    func bind(item: Channel) {
        channelTitle.text = item.name
    }
}
