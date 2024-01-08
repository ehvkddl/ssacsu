//
//  Separator.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/09.
//

import UIKit

class Divider: UIView {
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .View.separator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
