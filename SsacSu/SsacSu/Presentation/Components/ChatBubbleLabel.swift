//
//  ChatBubbleLabel.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/21.
//

import UIKit

class ChatBubbleLabel: UILabel {
    
    let padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    init() {
        super.init(frame: .zero)
        
        textColor = .Brand.black
        textAlignment = .left
        
        numberOfLines = 0
        lineBreakMode = .byCharWrapping
        
        font = SSFont.style(.body)
        
        backgroundColor = .Brand.white

        layer.borderWidth = 1
        layer.borderColor = UIColor(resource: .Brand.inactive).cgColor
        layer.cornerRadius = 12
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
        
        return contentSize
    }
    
}
