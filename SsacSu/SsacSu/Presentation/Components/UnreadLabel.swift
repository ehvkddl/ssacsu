//
//  UnreadLabel.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/28.
//

import UIKit

class UnreadLabel: UILabel {
    
    let padding = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
    
    init() {
        super.init(frame: .zero)
        
        textColor = .Brand.white
        textAlignment = .center
        font = SSFont.style(.caption)
        backgroundColor = .Brand.yellow
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += padding.left + padding.right
        contentSize.height += padding.top + padding.bottom
        
        guard contentSize.width > 19 else {
            contentSize.width = 19
            return contentSize
        }
        
        return contentSize
    }
    
}
