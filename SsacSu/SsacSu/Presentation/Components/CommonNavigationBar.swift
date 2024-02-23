//
//  CommonNavigationBar.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/19.
//

import UIKit

class CommonNavigationBar: BaseView {
    
    let leftItem = {
        let btn = UIButton()
        btn.contentMode = .scaleAspectFit
        return btn
    }()
    
    let title = {
        let lbl = UILabel()
        lbl.font = SSFont.style(.navTitle)
        lbl.textAlignment = .center
        return lbl
    }()
    
    let rightItem = {
        let btn = UIButton()
        btn.contentMode = .scaleAspectFit
        return btn
    }()
    
    let divider = Divider()

    init(
        title: String,
        leftItemImage: UIImage,
        rightItemImage: UIImage
    ) {
        super.init(frame: .zero)
        
        self.title.text = title
        self.leftItem.setImage(leftItemImage, for: .normal)
        self.rightItem.setImage(rightItemImage, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        [leftItem, title, rightItem,
         divider
        ].forEach { addSubview($0) }
    }
    
    override func setConstraints() {
        leftItem.setContentHuggingPriority(.init(751), for: .horizontal)
        leftItem.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.verticalEdges.equalToSuperview()
        }
        
        title.setContentHuggingPriority(.init(rawValue: 750), for: .horizontal)
        title.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.7)
            make.center.equalToSuperview()
        }
        
        rightItem.setContentHuggingPriority(.init(751), for: .horizontal)
        rightItem.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(14)
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(18)
        }
        
        divider.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
}
