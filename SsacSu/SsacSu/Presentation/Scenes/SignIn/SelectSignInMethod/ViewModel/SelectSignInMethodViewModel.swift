//
//  SelectSignInMethodViewModel.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/15.
//

import Foundation

import RxCocoa
import RxSwift

class SelectSignInMethodViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    private let appleLoginRepository: AppleLoginRepository
    
    init(appleLoginRepository: AppleLoginRepository) {
        self.appleLoginRepository = appleLoginRepository
    }
    
    struct Input {
        let vc: SelectSignInMethodViewController
        let appleSignInButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        input.appleSignInButtonTapped
            .subscribe(with: self) { owner, _ in
                owner.appleLoginRepository.performAppleLogin()
            }
            .disposed(by: disposeBag)
        
        appleLoginRepository.idToken
            .map { AppleLogin(idToken: $0) }
            .flatMap { SignManager.shared.appleLogin(with: $0) }
            .subscribe { value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
    
}
