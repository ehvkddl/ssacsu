//
//  UIImageView+.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/25.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func loadImage(url: String, size: CGSize) {
        let imageUrlStr = Configurations.baseURL + "v1" + url
        guard let imageUrl = URL(string: imageUrlStr) else { return }
        
        let header: [String: String] = {
            [
                "Authorization": Token.shared.load(account: .accessToken) ?? "",
                "SesacKey": Configurations.SeSACKey
            ]
        }()
        
        let imageDownloadRequest = AnyModifier { request in
            var r = request
            
            r.cachePolicy = .returnCacheDataElseLoad
            r.timeoutInterval = 10
            
            for (key, value) in header {
                r.addValue(value, forHTTPHeaderField: key)
            }
            
            return r
        }
        
        let processor = DownsamplingImageProcessor(size: size)
        
        kf.setImage(with: imageUrl,
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .cacheOriginalImage,
                        .requestModifier(imageDownloadRequest)
                    ])
    }
    
}
