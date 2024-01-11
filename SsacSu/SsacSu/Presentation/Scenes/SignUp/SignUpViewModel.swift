//
//  SignUpViewModel.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/10.
//

import Foundation

import RxCocoa
import RxSwift

enum EmailState  {
    case valid
    case invalid
    case usable
    case alreadyCheck
    case duplicated
}


class SignUpViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let email: ControlProperty<String>
        let nickname: ControlProperty<String>
        let phoneNumber: ControlProperty<String>
        let password: ControlProperty<String>
        let passwordCheck: ControlProperty<String>
        let checkEmailValidationButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let canValidationCheck: Observable<Bool>
        let emailState: PublishRelay<EmailState>
    }
    
    func transform(input: Input) -> Output {
        let emailState = PublishRelay<EmailState>()
        let isUsableEmail = BehaviorRelay<Bool>(value: false)
        
        let canValidationCheck = input.email
            .map { !$0.isEmpty }
        
        input.email
            .subscribe { _ in
                isUsableEmail.accept(false)
            }
            .disposed(by: disposeBag)
        
        let emailUsableState = Observable
            .combineLatest(isUsableEmail, input.email)
        
        input.checkEmailValidationButtonTapped
            .withLatestFrom(emailUsableState)
            .map { return (isUsable: $0, email: $1) }
            .subscribe(with: self) { owner, value in
                guard value.isUsable == false else {
                    emailState.accept(.alreadyCheck)
                    return
                }
                let isValid = owner.emailValidation(email: value.email)
                emailState.accept(isValid ? .valid : .invalid)
            }
            .disposed(by: disposeBag)
        
        emailState
            .filter { $0 == .valid }
            .withLatestFrom(input.email)
            .flatMap {
                SignManager.shared.checkEmailValidation(email: $0)
            }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { result in
                isUsableEmail.accept(true)
                emailState.accept(.usable)
            }
            .disposed(by: disposeBag)
        
        // 필수 항목들이 다 입력 됐는지 확인
        let isRequiredInputComplete = Observable<Bool>
            .combineLatest(input.email, 
                           input.nickname,
                           input.password,
                           input.passwordCheck
            ) {
                guard !$0.isEmpty else { return false }
                guard !$1.isEmpty else { return false }
                guard !$2.isEmpty else { return false }
                guard !$3.isEmpty else { return false }
                
                return true
            }
        
        return Output(
            canValidationCheck: canValidationCheck,
            emailState: emailState,
        )
    }
    
}

extension SignUpViewModel {
    
    func emailValidation(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
}
