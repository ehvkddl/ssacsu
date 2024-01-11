//
//  SignUpViewController.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/09.
//

import UIKit

import RxCocoa
import RxSwift

class SignUpViewController: BaseViewController {

    let vm = SignUpViewModel()
    
    let emailLabel = {
        let lbl = UILabel()
        lbl.text = "이메일"
        lbl.font = SSFont.style(.title2)
        return lbl
    }()
    let emailTextField = SSTextField(placeholder: "이메일을 입력하세요")
    
    let checkEmailValidationButton = SSButton(title: "중복 확인", style: .plain)
    
    let nicknameLabel = {
        let lbl = UILabel()
        lbl.text = "닉네임"
        lbl.font = SSFont.style(.title2)
        return lbl
    }()
    let nicknameTextField = SSTextField(placeholder: "닉네임을 입력하세요")
    
    let phoneNumberLabel = {
        let lbl = UILabel()
        lbl.text = "연락처"
        lbl.font = SSFont.style(.title2)
        return lbl
    }()
    let phoneNumberTextField = SSTextField(placeholder: "전화번호를 입력하세요")
    
    let passwordLabel = {
        let lbl = UILabel()
        lbl.text = "비밀번호"
        lbl.font = SSFont.style(.title2)
        return lbl
    }()
    let passwordTextField = SSTextField(placeholder: "비밀번호를 입력하세요")
    
    let passwordCheckLabel = {
        let lbl = UILabel()
        lbl.text = "비밀번호 확인"
        lbl.font = SSFont.style(.title2)
        return lbl
    }()
    let passwordCheckTextField = SSTextField(placeholder: "비밀번호를 한 번 더 입력하세요")
    
    let signUpButton = SSButton(title: "가입하기", style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }

    func bind() {
        let input = SignUpViewModel.Input(
            email: emailTextField.rx.text.orEmpty,
            nickname: nicknameTextField.rx.text.orEmpty,
            phoneNumber: phoneNumberTextField.rx.text.orEmpty,
            password: passwordTextField.rx.text.orEmpty,
            passwordCheck: passwordCheckTextField.rx.text.orEmpty,
            checkEmailValidationButtonTapped: checkEmailValidationButton.rx.tap
        )
        let output = vm.transform(input: input)
        
        output.canValidationCheck
            .bind(to: checkEmailValidationButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.emailState
            .subscribe(with: self) { owner, state in
                // TODO: - Toast로 바꾸기
                switch state {
                case .alreadyCheck: print("[이미 검증] 사용 가능한 이메일입니다.")
                case .invalid: print("이메일 형식이 올바르지 않습니다.")
                case .usable: print("사용 가능한 이메일입니다.")
                case .duplicated: print("중복 이메일입니다.")
                default: break
                }
            }
            .disposed(by: disposeBag)
        
        output.formattedPhoneNumber
            .bind(to: phoneNumberTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.isRequiredInputComplete
            .bind(to: signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        title = "회원가입"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .close, style: .plain, target: self, action: #selector(clickedCloseButton))
    }
    
    override func configureView() {
        [emailLabel, emailTextField,
         checkEmailValidationButton,
         nicknameLabel, nicknameTextField,
         phoneNumberLabel, phoneNumberTextField,
         passwordLabel, passwordTextField,
         passwordCheckLabel, passwordCheckTextField,
         signUpButton
        ].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.horizontalEdges.equalTo(signUpButton)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.leading.equalTo(emailLabel)
            make.height.equalTo(44)
        }
        
        checkEmailValidationButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(emailTextField)
            make.leading.equalTo(emailTextField.snp.trailing).offset(12)
            make.trailing.equalTo(signUpButton)
            make.width.equalTo(100)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(signUpButton)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(signUpButton)
            make.height.equalTo(44)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(signUpButton)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(signUpButton)
            make.height.equalTo(44)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(signUpButton)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(signUpButton)
            make.height.equalTo(44)
        }
        
        passwordCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(signUpButton)
        }
        
        passwordCheckTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordCheckLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(signUpButton)
            make.height.equalTo(44)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
    }
    
}

extension SignUpViewController {
    
    @objc func clickedCloseButton() {
        dismiss(animated: true)
    }
    
}
