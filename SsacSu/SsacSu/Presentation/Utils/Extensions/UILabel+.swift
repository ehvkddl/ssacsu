//
//  UILabel+.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/07.
//

import UIKit

extension UILabel {
    
    func setTextWithFont(text: String?, fontStyle: SSFontStyle) {
        if let text = text {
            var lineHeight: CGFloat = 0
            
            switch fontStyle {
            case .title1: lineHeight = 30
            case .title2: lineHeight = 20
            case .navTitle: lineHeight = 24
            case .bodyBold: lineHeight = 18
            case .body: lineHeight = 18
            case .caption: lineHeight = 18
            }
            
            font = SSFont.style(fontStyle)
            
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight) / 4
            ]
                
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            
            self.attributedText = attrString
        }
    }
    
}
