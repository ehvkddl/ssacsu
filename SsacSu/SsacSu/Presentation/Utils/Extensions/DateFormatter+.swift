//
//  DateFormatter+.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/26.
//

import Foundation

extension DateFormatter {
    
    enum SsacsuDateFormat: String {
        case iso8601WithMillisec = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" // ISO 8601 형식, 밀리초 포함
        case dateWithDots = "yy. MM. dd" // 년, 월, 일을 점(.)으로 구분
    }
    
    private static let dateFormater: DateFormatter = {
        return DateFormatter()
    }()
    
    static let iso8601: DateFormatter = {
        dateFormater.dateFormat = SsacsuDateFormat.iso8601WithMillisec.rawValue
        dateFormater.timeZone = TimeZone(identifier: "Asia/Seoul")
        return dateFormater
    }()
    
    static let dateWithDots: DateFormatter = {
        dateFormater.dateFormat = SsacsuDateFormat.dateWithDots.rawValue
        dateFormater.timeZone = TimeZone(identifier: "Asia/Seoul")
        return dateFormater
    }()
    
}
