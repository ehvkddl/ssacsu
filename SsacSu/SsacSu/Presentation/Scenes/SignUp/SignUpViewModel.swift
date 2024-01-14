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

struct InputData {
    let email: String
    let nickname: String
    let phoneNumber: String
    let password: String
    let passwordCheck: String
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
        let signUpButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let canValidationCheck: Observable<Bool>
        let emailState: PublishRelay<EmailState>
        let formattedPhoneNumber: PublishRelay<String>
        let isRequiredInputComplete: Observable<Bool>
        let inputUsableState: BehaviorRelay<(Bool, Bool, Bool, Bool, Bool)>
        let isSignUpComplete: BehaviorRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        let emailState = PublishRelay<EmailState>()
        let isUsableEmail = BehaviorRelay<Bool>(value: false)
        
        let formattedPhoneNumber = PublishRelay<String>()
        
        let inputUsableState = BehaviorRelay<(Bool, Bool, Bool, Bool, Bool)>(value: (email: true, 
                                                                                     nickname: true,
                                                                                     phone: true,
                                                                                     pw: true,
                                                                                     pwcheck: true))
        
        let canSignUp = BehaviorRelay<Bool>(value: false)
        let isSignUpComplete = BehaviorRelay<Bool>(value: false)
        
        let canValidationCheck = input.email
            .map { !$0.isEmpty }
        
        // 이메일이 수정되면 중복확인 다시 진행돼야하기 때문에 변화 발생시 isUsableEmail을 false로 변경
        input.email
            .distinctUntilChanged()
            .subscribe { _ in
                isUsableEmail.accept(false)
            }
            .disposed(by: disposeBag)
        
        // emailState 판별하기 위한 옵저버블
        let emailUsableState = Observable
            .combineLatest(isUsableEmail, input.email)
        
        // 중복 확인 버튼 클릭시 이메일 유효성 판단
        input.checkEmailValidationButtonTapped
            .withLatestFrom(emailUsableState)
            .map { return (isUsable: $0, email: $1) }
            .subscribe(with: self) { owner, value in
                guard value.isUsable == false else {
                    emailState.accept(.alreadyCheck)
                    return
                }
                let isValid = Validation(string: value.email).isEmail
                emailState.accept(isValid ? .valid : .invalid)
            }
            .disposed(by: disposeBag)
        
        // 이메일이 유효하다면 중복 확인 진행
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
        
        // 핸드폰 번호 형식
        input.phoneNumber
            .subscribe { value in
                let result = value.withHypen
                
                guard result.count < 13 else {
                    let index = result.index(result.startIndex, offsetBy: 13)
                    let newString = result[result.startIndex..<index]
                    formattedPhoneNumber.accept(String(newString))
                    
                    return
                }
                
                formattedPhoneNumber.accept(result)
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
        
        // 회원가입에 필요한 요소 모음
        let singUpData = Observable
            .combineLatest(isUsableEmail, 
                           input.email,
                           input.nickname,
                           input.phoneNumber,
                           input.password,
                           input.passwordCheck
            )
            .map { (isUsableEmail: $0, 
                    inputData: InputData(email: $1,
                                         nickname: $2,
                                         phoneNumber: $3,
                                         password: $4,
                                         passwordCheck: $5)
            ) }
        
        // 버튼 클릭시 유효성 판단
        input.signUpButtonTapped
            .withLatestFrom(singUpData)
            .subscribe { singUpData in
                guard let data = singUpData.element else { return }
                
                let isUsableEmail = data.isUsableEmail
                let input = data.inputData
                
                let nickValidation = (1...30 ~= input.nickname.count)
                let phnValidation = input.phoneNumber.isEmpty ? true : Validation(string: input.phoneNumber.withoutHypen).isPhoneNumber
                let pwValidation = Validation(string: input.password).isPassword
                let pwEqual = input.password.compare(input.passwordCheck) == .orderedSame
                
                inputUsableState.accept((isUsableEmail, nickValidation, phnValidation, pwValidation, pwEqual))
                
                let isWholeInputValid = isUsableEmail && nickValidation && phnValidation && pwValidation && pwEqual

                canSignUp.accept(isWholeInputValid)
            }
            .disposed(by: disposeBag)
            
        // 유효성 판단 후 회원가입이 가능한 상태면 가입 진행
        canSignUp
            .filter { $0 == true }
            .withLatestFrom(singUpData)
            .map { signUpData in
                let input = signUpData.inputData
                return Join(email: input.email, 
                            password: input.password,
                            nickname: input.nickname,
                            phone: input.phoneNumber)
            }
            .flatMap {
                SignManager.shared.join(join: $0)
            }
            .subscribe { result in
                isSignUpComplete.accept(true)
            }
            .disposed(by: disposeBag)
        
        return Output(
            canValidationCheck: canValidationCheck,
            emailState: emailState,
            formattedPhoneNumber: formattedPhoneNumber,
            isRequiredInputComplete: isRequiredInputComplete,
            inputUsableState: inputUsableState,
            isSignUpComplete: isSignUpComplete
        )
    }
    
}
