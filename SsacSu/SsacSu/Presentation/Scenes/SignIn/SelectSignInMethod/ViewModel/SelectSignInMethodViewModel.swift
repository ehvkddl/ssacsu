//
//  SelectSignInMethodViewModel.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/15.
//

import Foundation

import RxCocoa
import RxSwift

protocol SelectSignInMethodViewModelDelegate {
    func signUp()
    func emailSignIn()
}

class SelectSignInMethodViewModel: ViewModelType {
    
    var delegate: SelectSignInMethodViewModelDelegate?
    
    private let signRepository: SignRepository
    private let disposeBag = DisposeBag()
    
    private let appleLoginRepository: AppleLoginRepository
    private let kakaoLoginRepository: KakaoLoginRepository
    
    init(signRepository: SignRepository,
         appleLoginRepository: AppleLoginRepository,
         kakaoLoginRepository: KakaoLoginRepository
    ) {
        self.signRepository = signRepository
        self.appleLoginRepository = appleLoginRepository
        self.kakaoLoginRepository = kakaoLoginRepository
    }
    
    struct Input {
        let appleSignInButtonTapped: ControlEvent<Void>
        let kakaoSignInButtonTapped: ControlEvent<Void>
        let emailSignInButtonTapped: ControlEvent<Void>
        let signUpButtonTapped: ControlEvent<Void>
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
            .flatMap { self.signRepository.appleLogin(with: $0) }
            .subscribe { value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        input.kakaoSignInButtonTapped
            .subscribe(with: self) { owner, _ in
                owner.kakaoLoginRepository.performKakaoLogin()
            }
            .disposed(by: disposeBag)
        
        kakaoLoginRepository.oauthToken
            .map { KakaoLogin(oauthToken: $0) }
            .flatMap { self.signRepository.kakaoLogin(with: $0) }
            .subscribe(with: self) { owner, result in
                print(result)
            }
            .disposed(by: disposeBag)
        
        input.emailSignInButtonTapped
            .subscribe(with: self) { owner, _ in
                owner.delegate?.emailSignIn()
            }
            .disposed(by: disposeBag)
        
        input.signUpButtonTapped
            .subscribe(with: self) { owner, _ in
                owner.delegate?.signUp()
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
    
}
