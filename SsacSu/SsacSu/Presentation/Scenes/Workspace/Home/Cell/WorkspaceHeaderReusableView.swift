//
//  WorkCollectionReusableHeaderView.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/27.
//

import UIKit

import RxSwift

class WorkspaceHeaderReusableView: UICollectionReusableView {
    
    let disposeBag = DisposeBag()
    
    let titleLabel = {
        let lbl = UILabel()
        lbl.textColor = .Brand.black
        lbl.font = SSFont.style(.title2)
        return lbl
    }()
    
    let disclosureIndicator = {
        let img = UIImageView()
        img.image = UIImage(resource: .Chevron.down)
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureHeader()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeader() {
        [titleLabel, disclosureIndicator].forEach { addSubview($0) }
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).inset(13)
            make.verticalEdges.equalTo(self).inset(14)
        }
        
        disclosureIndicator.snp.makeConstraints { make in
            make.trailing.equalTo(self).inset(16)
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(24)
        }
    }
    
    func bind(title: String) {
        titleLabel.text = title
    }
    
}
