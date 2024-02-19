//
//  WorkspaceListViewModel.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/31.
//

import UIKit

import RxCocoa
import RxSwift

final class WorkspaceListViewModel: ViewModelType {
    
    private let workspaceRepository: WorkspaceRepository
    private let disposeBag = DisposeBag()
    
    init(workspaceRepository: WorkspaceRepository) {
        self.workspaceRepository = workspaceRepository
    }
    
    struct Input {
    }
    
    struct Output {
    }
    
    func transform(input: Input) -> Output {
    }
    
}
