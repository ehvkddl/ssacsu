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
    
    var selectWorkspace: ((Int) -> Void)?
    
    init(workspaceRepository: WorkspaceRepository) {
        self.workspaceRepository = workspaceRepository
    }
    
    struct Input {
        let backgroundTapGesture: ControlEvent<UITapGestureRecognizer>
        let itemSelected: ControlEvent<IndexPath>
        let modelSelected: ControlEvent<Workspace>
    }
    
    struct Output {
        let workspaceList: PublishSubject<[Workspace]>
    }
    
    func transform(input: Input) -> Output {
        let workspaceList = PublishSubject<[Workspace]>()
        
        input.backgroundTapGesture
            .subscribe(with: self) { owner, _ in
                owner.delegate?.closeWorkspaceList()
            }
            .disposed(by: disposeBag)
        
        Observable.just(())
            .flatMap { self.workspaceRepository.fetchWorkspace() }
            .subscribe { result in
                switch result {
                case .success(let success):
                    let list = success.map { $0.toDomain() }
                    
                    workspaceList.onNext(list)
                    
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.zip(input.itemSelected, input.modelSelected)
            .map { (indexPath: $0.0, model: $0.1) }
            .subscribe(with: self) { owner, cell in
                print("[cell click]", cell.indexPath, cell.model)
                
                owner.selectWorkspace?(cell.model.workspaceID)
            }
            .disposed(by: disposeBag)
        
        return Output(workspaceList: workspaceList)
    }
    
}
