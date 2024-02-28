//
//  EmailSignInViewModel.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/14.
//

import UIKit

import RxCocoa
import RxSwift

protocol EmailSignInViewModelDelegate {
    func login()
}

class EmailSignInViewModel: ViewModelType {
    
    var delegate: EmailSignInViewModelDelegate?
    
    private let signRepository: SignRepository
    private let disposeBag = DisposeBag()
    
    init(signRepository: SignRepository) {
        self.signRepository = signRepository
    }
    
    struct Input {
        let email: ControlProperty<String>
        let password: ControlProperty<String>
        let signInButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let isRequiredInputComplete: Observable<Bool>
        let inputUsableState: BehaviorRelay<(Bool, Bool)>
    }
    
    func transform(input: Input) -> Output {
        let inputUsableState = BehaviorRelay<(Bool, Bool)>(value: (email: true,
                                                                   password: true))
        let canSignIn = BehaviorRelay<Bool>(value: false)
        
        
        let isRequiredInputComplete = Observable<Bool>
            .combineLatest(input.email, input.password) { email, password in
                guard !email.isEmpty else { return false }
                guard !password.isEmpty else { return false }
                
                return true
            }
        
        let userInput = Observable
            .combineLatest(input.email, input.password)
            .map { (email: $0.0, password: $0.1) }
        
        input.signInButtonTapped
            .withLatestFrom(userInput)
            .subscribe {
                guard let userInput = $0.element else { return }
                
                let emailValidation = Validation(string: userInput.email).isEmail
                let passwordValidation = Validation(string: userInput.password).isPassword
                
                inputUsableState.accept((emailValidation, passwordValidation))
                
                let isWholeInputValid = emailValidation && passwordValidation
                
                canSignIn.accept(isWholeInputValid)
            }
            .disposed(by: disposeBag)
        
        canSignIn
            .filter { $0 == true }
            .withLatestFrom(userInput)
            .map {
                EmailLogin(email: $0.email, password: $0.password)
            }
            .flatMap {
                self.signRepository.login(with: $0)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    let token = response.token
                    
                    Token.shared.save(account: .accessToken, value: token.accessToken)
                    Token.shared.save(account: .refreshToken, value: token.refreshToken)
                    
                    let user = User(userID: response.userID,
                                    email: response.email,
                                    nickname: response.nickname,
                                    profileImage: response.profileImage)
                    
                    UserDefaultsManager.user = user
                    
                    // 워크스페이스로 넘어가기
                    print("로그인 성공 메인뷰로 넘어가요옹")
                    owner.delegate?.login()
                    
                case .failure(let error):
                    guard error == .authenticationFailure else { return }

                    // TODO: - 로그인 실패 Toast
                    print("로그인 실패")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            isRequiredInputComplete: isRequiredInputComplete,
            inputUsableState: inputUsableState
        )
    }
    
}
