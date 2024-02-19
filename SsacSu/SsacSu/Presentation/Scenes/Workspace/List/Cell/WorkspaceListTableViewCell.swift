//
//  WorkspaceListTableViewCell.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/31.
//

import UIKit

class WorkspaceListTableViewCell: BaseTableViewCell {
    
    let thumbnailImage = {
        let img = UIImageView()
        img.backgroundColor = .systemGray
        img.layer.cornerRadius = 8
        return img
    }()
    
    let stackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        return sv
    }()
    
    let nameLabel = {
        let lbl = UILabel()
        lbl.text = "워크스페이스 이름"
        lbl.font = SSFont.style(.bodyBold)
        return lbl
    }()
    
    let createdAtLabel = {
        let lbl = UILabel()
        lbl.text = "생성일"
        lbl.font = SSFont.style(.body)
        return lbl
    }()
    
    override func configureView() {
        [nameLabel,
        createdAtLabel
        ].forEach { stackView.addArrangedSubview($0) }
        
        [thumbnailImage,
         stackView
        ].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        thumbnailImage.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(17)
            make.verticalEdges.equalTo(contentView).inset(14)
            make.centerY.equalTo(contentView)
            make.size.equalTo(44)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(thumbnailImage.snp.trailing).offset(8)
            make.verticalEdges.equalTo(thumbnailImage).inset(4)
        }
    }
    
}
