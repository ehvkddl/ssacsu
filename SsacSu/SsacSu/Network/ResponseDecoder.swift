//
//  ResponseDecoder.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/24.
//

import Foundation

struct ResponseDecoder {
    
    static func decode<T: Decodable>(_ type: T.Type, data: Data) -> Result<T, Error> {
        do {
            let decoded = try JSONDecoder().decode(type, from: data)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }
    
}
