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
    
    private let workspaceRepository: WorkspaceRepository
    private let disposeBag = DisposeBag()
    
    init(workspaceRepository: WorkspaceRepository) {
        self.workspaceRepository = workspaceRepository
    }
    
    struct Input {
        let createWorkspaceButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let workspace: PublishSubject<Workspace?>
    }
    
    func transform(input: Input) -> Output {
        let workspace = PublishSubject<Workspace?>()
        
        Observable.just(182)
            .flatMap { self.workspaceRepository.fetchSingleWorkspace(id: $0) }
            .debug()
            .subscribe { result in
                dump(result)
                switch result {
                case .success(let response):
                    workspace.onNext(response.toDomain())
                    
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.createWorkspaceButtonTapped
            .subscribe { _ in
                print("워크스페이스 생성")
            }
            .disposed(by: disposeBag)
        
        return Output(
            workspace: workspace
        )
    }
    
}
