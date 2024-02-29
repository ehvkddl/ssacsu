//
//  ChattingBubbleTableViewCell.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/21.
//

import UIKit

final class OtherChattingBubbleTableViewCell: BaseTableViewCell {
    
    let profileImage = {
        let view = UIImageView()
        view.backgroundColor = .systemYellow
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    let nicknameLabel = {
        let lbl = UILabel()
        lbl.text = "nickname"
        lbl.font = SSFont.style(.caption)
        return lbl
    }()
    
    let chatBubbleLabel = {
        let lbl = ChatBubbleLabel()
        lbl.text = "Hello World!!"
        return lbl
    }()
    
    let timeLabel = {
        let lbl = UILabel()
        lbl.text = "08:16 오전"
        lbl.textColor = .Text.secondary
        lbl.textAlignment = .left
        lbl.font = SSFont.style(.timeCaption)
        return lbl
    }()
    
    override func configureView() {
        [profileImage, nicknameLabel,
         chatBubbleLabel, timeLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(6)
            make.leading.equalTo(contentView).inset(16)
            make.size.equalTo(34)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
        }
        
        chatBubbleLabel.setContentHuggingPriority(.init(rawValue: 751), for: .horizontal)
        chatBubbleLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            make.leading.equalTo(nicknameLabel)
            make.bottom.equalTo(contentView).inset(6)
        }
        
        timeLabel.setContentHuggingPriority(.init(750), for: .horizontal)
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(chatBubbleLabel.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).inset(30)
            make.bottom.equalTo(chatBubbleLabel)
        }
    }
    
}
