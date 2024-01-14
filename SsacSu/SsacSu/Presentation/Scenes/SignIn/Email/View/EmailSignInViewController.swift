//
//  EmailSignInViewController.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/13.
//

import UIKit

class EmailSignInViewController: BaseViewController {
    
    let vm = EmailSignInViewModel()
    
    let emailLabel = SSLabel(text: "이메일",
                             font: SSFont.style(.title2),
                             textAlignment: .left)
    let emailTextField = SSTextField(placeholder: "이메일을 입력하세요.")
    
    let passwordLabel = SSLabel(text: "비밀번호",
                                font: SSFont.style(.title2),
                                textAlignment: .left)
    let passwordTextField = SSTextField(placeholder: "비밀번호를 입력하세요.")
    
    let signInButton = SSButton(title: "로그인", style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        let input = EmailSignInViewModel.Input(
            email: emailTextField.rx.text.orEmpty,
            password: passwordTextField.rx.text.orEmpty,
            signInButtonTapped: signInButton.rx.tap
        )
        let output = vm.transform(input: input)
        
        output.isRequiredInputComplete
            .bind(to: signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.inputUsableState
            .map { (email: $0.0, password: $0.1) }
            .subscribe(with: self) { owner, state in
                owner.emailLabel.textColor = state.email ? .Brand.black : .Brand.error
                owner.passwordLabel.textColor = state.password ? .Brand.black : . Brand.error
                
                // TODO: - Toast
                guard state.email else {
                    print("이메일 형식이 올바르지 않습니다.")
                    owner.emailTextField.becomeFirstResponder()
                    return
                }
                
                guard state.password else {
                    print("비밀번호는 최소 8자 이상, 하나 이상의 대소문자/숫자/특수 문자입니다.")
                    owner.passwordTextField.becomeFirstResponder()
                    return
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        title = "이메일 로그인"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .close, style: .plain, target: self, action: #selector(closeButtonClicked))
    }
    
    override func configureView() {
        [emailLabel, emailTextField,
         passwordLabel, passwordTextField,
         signInButton
        ].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(view).inset(24)
            make.horizontalEdges.equalTo(signInButton)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(signInButton)
            make.height.equalTo(44)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(signInButton)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(signInButton)
            make.height.equalTo(44)
        }
        
        signInButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view).inset(24)
            make.height.equalTo(44)
            make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).offset(-12)
        }
    }
    
}

extension EmailSignInViewController {
    
    @objc func closeButtonClicked() {
        dismiss(animated: true)
    }
    
}
