//
//  EmailSignInViewController.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/13.
//

import UIKit

class EmailSignInViewController: BaseViewController {
    
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
