//
//  DateFormatter+.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/26.
//

import Foundation

extension DateFormatter {
    
    static let ssacsuDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return df
    }()
    
}
