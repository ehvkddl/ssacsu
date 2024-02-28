//
//  DmsRepository.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/28.
//

import Foundation

protocol DmsRepository {
    func fetchDmsRoom(id workspaceID: Int, completion: @escaping ([DMsRoom]) -> Void)
}
