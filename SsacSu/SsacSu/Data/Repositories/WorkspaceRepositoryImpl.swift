//
//  WorkspaceRepositoryImpl.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/23.
//

import Foundation

import RxSwift

final class WorkspaceRepositoryImpl {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
}

extension WorkspaceRepositoryImpl: WorkspaceRepository {
    
}
