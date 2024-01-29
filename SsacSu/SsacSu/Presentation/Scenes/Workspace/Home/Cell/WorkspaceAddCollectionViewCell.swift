//
//  WorkspaceAddCollectionCell.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/28.
//

import UIKit

class WorkspaceAddCollectionViewCell: BaseCollectionViewCell {
    
    let plusImage = UIImageView(image: .plus)
    
    let addTitleLabel = {
        let lbl = UILabel()
        lbl.text = "채널 추가"
        lbl.textColor = .Text.secondary
        lbl.font = SSFont.style(.body)
        return lbl
    }()
    
    override func configureCell() {
        [plusImage, addTitleLabel].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        plusImage.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(16)
            make.centerY.equalTo(contentView)
            make.size.equalTo(18)
        }
        
        addTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(plusImage.snp.trailing).offset(16)
            make.centerY.equalTo(plusImage)
        }
    }
    
}
