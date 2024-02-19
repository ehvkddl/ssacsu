//
//  WorkspaceListViewModel.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/31.
//

import UIKit

import RxCocoa
import RxSwift

protocol workspaceListViewModelDelegate {
    func closeWorkspaceList()
}

final class WorkspaceListViewModel: ViewModelType {
    
    var delegate: workspaceListViewModelDelegate?
    
    private let workspaceRepository: WorkspaceRepository
    private let disposeBag = DisposeBag()
    
    init(workspaceRepository: WorkspaceRepository) {
        self.workspaceRepository = workspaceRepository
    }
    
    struct Input {
        let backgroundTapGesture: ControlEvent<UITapGestureRecognizer>
    }
    
    struct Output {
    }
    
    func transform(input: Input) -> Output {
        input.backgroundTapGesture
            .subscribe(with: self) { owner, _ in
                owner.delegate?.closeWorkspaceList()
            }
            .disposed(by: disposeBag)
    }
    
}
