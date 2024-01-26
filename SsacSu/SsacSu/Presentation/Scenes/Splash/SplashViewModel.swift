//
//  SplashViewModel.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/23.
//

import Foundation

import RxSwift

protocol SplashViewModelDelegate {
    func showOnboardingView()
    func showWorkspaceView()
}

class SplashViewModel {
    
    var delegate: SplashViewModelDelegate?
    
    private let workspaceRepository: WorkspaceRepository
    private let disposeBag = DisposeBag()
    
    init(workspaceRepository: WorkspaceRepository) {
        self.workspaceRepository = workspaceRepository
    }
    
    func showAppropriateView() {
        guard Token.shared.load(account: .accessToken) != nil else {
            delegate?.showOnboardingView()
            return
        }
        
        Observable.just(())
            .flatMap { self.workspaceRepository.fetchWorkspace() }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print(response)
                    owner.delegate?.showWorkspaceView()
                    
                case .failure(let error):
                    print("워크스페이스 조회실패", error)
                    owner.delegate?.showOnboardingView()
                }
            } onError: { owner, result in
                owner.delegate?.showOnboardingView()
            }
            .disposed(by: disposeBag)
    }
    
}
