//
//  SSTextField.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/09.
//

import UIKit

class SSTextField: UITextField {
    
    let _placeholder: String
    
    let insets: UIEdgeInsets = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
    
    init(placeholder _placeholder: String) {
        self._placeholder = _placeholder
        
        super.init(frame: .zero)
        
        placeholder = _placeholder
        font = SSFont.style(.body)
        backgroundColor = .Background.secondary
        layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
}
