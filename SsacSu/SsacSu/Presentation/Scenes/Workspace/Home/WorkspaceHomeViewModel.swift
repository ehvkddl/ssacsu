//
//  WorkspaceHomeViewModel.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/23.
//

import Foundation

import RxCocoa
import RxSwift

class WorkspaceHomeViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let createWorkspaceButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        input.createWorkspaceButtonTapped
            .subscribe { _ in
                print("워크스페이스 생성")
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
    
}
