//
//  SSButton.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/07.
//

import UIKit

enum SSButtonStyle {
    case plain // Yellow Color
    case cancel // Gray Color
    case image // Yellow Color
    case border // Black Color + Border
    case borderDestructive // Red Color + Border
    case custom // Custom Color
}

class SSButton: UIButton {
    
    let image: UIImage?
    let title: String
    let fgColor: UIColor?
    let bgColor: UIColor?
    let cornerRadius: CGFloat = 8
    let style: SSButtonStyle
    
    init(image: UIImage? = nil,
         title: String,
         fgColor: UIColor? = .black,
         bgColor: UIColor? = nil,
         style: SSButtonStyle
    ) {
        self.image = image
        self.title = title
        self.fgColor = fgColor
        self.bgColor = bgColor
        self.style = style
        
        super.init(frame: .zero)
        
        set()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set() {
        var config = UIButton.Configuration.filled()
        config.title = title
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = SSFont.style(.title2)
            return outgoing
        }
        
        config.image = image
        config.imagePadding = 4
        config.imagePlacement = .leading
        
        config.background.cornerRadius = self.cornerRadius
        
        switch style {
        case .plain:
            config.baseForegroundColor = .Brand.white
            config.baseBackgroundColor = .Brand.yellow
            
        case .cancel:
            config.baseForegroundColor = .Brand.white
            config.baseBackgroundColor = .Brand.inactive
            
        case .image:
            config.baseForegroundColor = .Brand.white
            config.baseBackgroundColor = .Brand.yellow
            
        case .border:
            config.baseForegroundColor = .Brand.black
            config.baseBackgroundColor = .Brand.white
            config.background.strokeColor = .Brand.black
            config.background.strokeWidth = 1
            
        case .borderDestructive:
            config.baseForegroundColor = .Brand.error
            config.baseBackgroundColor = .Brand.white
            config.background.strokeColor = .Brand.error
            config.background.strokeWidth = 1
            
        case .custom:
            config.baseForegroundColor = fgColor
            config.baseBackgroundColor = bgColor
        }
        
        configuration = config
    }
    
}
