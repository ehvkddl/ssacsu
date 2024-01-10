//
//  EmailValidationRequestDTO.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/10.
//

import Foundation

struct EmailValidationRequestDTO: Encodable {
    let email: String
}

struct EmailValidationResponseDTO: Decodable {
    let errorCode: String
}
