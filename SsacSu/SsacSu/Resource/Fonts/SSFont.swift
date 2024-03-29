//
//  SSFont.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/05.
//

import UIKit

enum SSFontStyle {
    case title1
    case title2
    case navTitle
    case bodyBold
    case body
    case caption
    case timeCaption
}

enum SSFont: String {
    
    case Regular = "SFPro-Regular"
    case semiBold = "SFPro-Semibold"
    case Bold = "SFPro-Bold"

    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
    
    static func style(_ fontStyle: SSFontStyle) -> UIFont {
        switch fontStyle {
        case .title1:
            return SSFont.Bold.of(size: 22)
        case .title2:
            return SSFont.Bold.of(size: 14)
        case .navTitle:
            return SSFont.semiBold.of(size: 17)
        case .bodyBold:
            return SSFont.Bold.of(size: 13)
        case .body:
            return SSFont.Regular.of(size: 13)
        case .caption:
            return SSFont.Regular.of(size: 12)
        case .timeCaption:
            return SSFont.Regular.of(size: 11)
        }
    }
    
}
