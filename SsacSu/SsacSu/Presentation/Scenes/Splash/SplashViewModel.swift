//
//  SplashViewModel.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/23.
//

import Foundation

import RxSwift

protocol SplashViewModelDelegate {
    func logout()
    func login()
}

class SplashViewModel {
    
    var delegate: SplashViewModelDelegate?
    
    private let disposeBag = DisposeBag()
    
    func showAppropriateView() {
        guard Token.shared.load(account: .accessToken) != nil else {
            delegate?.logout()
            return
        }
        
        Observable.just(())
            .subscribe(with: self) { owner, _ in
                AuthManager.shared.refreshAccessToken { result in
                    switch result {
                    case .success:
                        owner.delegate?.login()
                        
                    case .failure(let error):
                        guard error == .validToken else {
                            owner.delegate?.logout()
                            
                            return
                        }
                        
                        owner.delegate?.login()
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
}
