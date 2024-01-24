//
//  SsacsuError.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/19.
//

import Foundation

enum SsacsuError: String, Error {
    case decodingFailure
    
    case accessPermission = "E01"
    case unknownRouterPath = "E97"
    case accessTokenExpired = "E05"
    case authenticationFailure = "E02"
    case unknownAccount = "E03"
    case overcall = "E98"
    case serverError = "E99"
    
    case validToken = "E04"
    
    case invalidRequest = "E11"
    case duplicatedData = "E12"
}
