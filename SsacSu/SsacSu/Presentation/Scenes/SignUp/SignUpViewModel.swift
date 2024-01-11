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
                let isValid = owner.emailValidation(email: value.email)
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
                
                let nickValidation = self.nicknameValidation(nickname: input.nickname)
                let phnValidation = input.phoneNumber.isEmpty ? true : self.phoneNumberValidation(phoneNumber: input.phoneNumber.withoutHypen)
                let pwValidation = self.passwordValidation(password: input.password)
                let pwEqual = self.passwordEqual(password: input.password, passwordCheck: input.passwordCheck)
                
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
                return User(email: input.email, 
                            password: input.password,
                            nickname: input.nickname,
                            phone: input.phoneNumber)
            }
            .flatMap {
                SignManager.shared.join(user: $0)
            }
            .subscribe { result in
                print("[가입요청]", result)
            }
            .disposed(by: disposeBag)
        
        return Output(
            canValidationCheck: canValidationCheck,
            emailState: emailState,
            formattedPhoneNumber: formattedPhoneNumber,
            isRequiredInputComplete: isRequiredInputComplete,
            inputUsableState: inputUsableState
        )
    }
    
}

extension SignUpViewModel {
    
    func emailValidation(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.com"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func nicknameValidation(nickname: String) -> Bool {
        return 1...30 ~= nickname.count
    }
    
    func phoneNumberValidation(phoneNumber: String) -> Bool {
        let phnRegex = "^01[0-1, 7][0-9]{7,8}$"
        return NSPredicate(format: "SELF MATCHES %@", phnRegex).evaluate(with: phoneNumber)
    }
    
    func passwordValidation(password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,20}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    func passwordEqual(password: String, passwordCheck: String) -> Bool {
        return password.compare(passwordCheck) == .orderedSame
    }
    
}
