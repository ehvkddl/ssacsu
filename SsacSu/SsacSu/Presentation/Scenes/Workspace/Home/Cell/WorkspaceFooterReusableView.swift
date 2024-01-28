//
//  WorkspaceFooterReusable.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/29.
//

import UIKit

class WorkspaceFooterReusableView: UICollectionReusableView {
    
    let divider = Divider()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureHeader()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeader() {
        addSubview(divider)
    }
    
    func setConstraints() {
        divider.snp.makeConstraints { make in
            make.top.equalTo(self).inset(5)
            make.horizontalEdges.equalTo(self)
            make.height.equalTo(1)
        }
    }
    
}
