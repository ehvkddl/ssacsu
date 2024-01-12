//
//  SSLabel.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/13.
//

import UIKit

class SSLabel: UILabel {
    
    let _text: String
    let _textColor: UIColor?
    let _font: UIFont
    let _textAlignment: NSTextAlignment?
    
    init(text _text: String,
         textColor _textColor: UIColor? = .Brand.black,
         font _font: UIFont,
         textAlignment _textAlignment: NSTextAlignment? = .center
    ) {
        self._text = _text
        self._textColor = _textColor
        self._font = _font
        self._textAlignment = _textAlignment
        
        super.init(frame: .zero)
        
        guard let _textAlignment else { return }
        
        text = _text
        textColor = _textColor
        font = _font
        textAlignment = _textAlignment
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
