//
//  EmailSignInViewModel.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/14.
//

import UIKit

import RxCocoa
import RxSwift

class EmailSignInViewModel: ViewModelType {
    
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
                Login(email: $0.email, password: $0.password)
            }
            .flatMap {
                self.signRepository.login(with: $0)
            }
            .subscribe { response in
                dump(response)
            }
            .disposed(by: disposeBag)
        
        return Output(
            isRequiredInputComplete: isRequiredInputComplete,
            inputUsableState: inputUsableState
        )
    }
    
}
