//
//  ImageDownloader.swift
//  SsacSu
//
//  Created by do hee kim on 2024/03/01.
//

import UIKit

import Kingfisher

struct ImageHelper {
    
    static func download(url: String, size: CGSize, completion: @escaping (UIImage) -> Void) {
        print("\n이미지 다운 안받니???\n")
        
        let imageUrlStr = Configurations.baseURL + "v1" + url
        guard let imageUrl = URL(string: imageUrlStr) else { print("url 변환 실패에요 ㅡㅡ"); return }
        
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
        
        KingfisherManager.shared.retrieveImage(with: imageUrl,
                                               options: [
                                                .processor(processor),
                                                .scaleFactor(UIScreen.main.scale),
                                                .cacheOriginalImage,
                                                .requestModifier(imageDownloadRequest)
                                               ]) { result in
            switch result {
            case .success(let value):
                print("\n이미지 다운로드 성공!!!!!!!1\n")
                completion(value.image)
                
            case .failure(let error):
                print("\n이미지 다운로드 실패!!!!!!!1 Error: \(error)\n")
            }
        }
    }
    
}
