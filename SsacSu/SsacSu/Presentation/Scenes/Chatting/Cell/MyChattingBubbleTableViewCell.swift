//
//  MyChattingBubbleTableViewCell.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/21.
//

import UIKit

final class MyChattingBubbleTableViewCell: BaseTableViewCell {
    
    let chatBubbleLabel = {
        let lbl = ChatBubbleLabel()
        lbl.text = "Hello World!!"
        return lbl
    }()
    
    let timeLabel = {
        let lbl = UILabel()
        lbl.text = "08:16 오전"
        lbl.textColor = .Text.secondary
        lbl.textAlignment = .right
        lbl.font = SSFont.style(.timeCaption)
        return lbl
    }()
    
    override func configureView() {
        [chatBubbleLabel, timeLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        chatBubbleLabel.setContentHuggingPriority(.init(rawValue: 751), for: .horizontal)
        chatBubbleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(6)
            make.trailing.equalTo(contentView).inset(16)
            make.bottom.equalTo(contentView).inset(6)
        }
        
        timeLabel.setContentHuggingPriority(.init(750), for: .horizontal)
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(30)
            make.trailing.equalTo(chatBubbleLabel.snp.leading).offset(-8)
            make.bottom.equalTo(chatBubbleLabel)
        }
    }
    
}
