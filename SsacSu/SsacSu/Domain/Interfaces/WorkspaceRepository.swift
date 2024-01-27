//
//  WorkspaceRepository.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/23.
//

import Foundation

import RxSwift

protocol WorkspaceRepository {
    
    func fetchWorkspace() -> Single<Result<WorkspaceList, SsacsuError>>
    func fetchSingleWorkspace(id: Int) -> Single<Result<WorkspaceResponseDTO, SsacsuError>>
    
}
