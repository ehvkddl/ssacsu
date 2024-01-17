//
//  SelectSignInMethodViewController.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/08.
//

import UIKit
import AuthenticationServices

class SelectSignInMethodViewController: BaseViewController {

    var vm: SelectSignInMethodViewModel!
    
    private let appleSignInButton = SSButton(image: .SignIn.apple,
                                             bgColor: .Brand.black,
                                             style:.image)
    
    private let kakaoSignInButton = SSButton(image: .SignIn.kakao,
                                             style: .image)
    
    private let emailSignInButton = SSButton(image: .email,
                                             title: "이메일로 계속하기",
                                             style: .imageWithTitle)
    
    private let signUpButton = SSButton(title: "또는 새롭게 회원가입 하기",
                                        fgColor: .Brand.black,
                                        style: .custom)
  
    static func create(
        with viewModel: SelectSignInMethodViewModel
    ) -> SelectSignInMethodViewController {
        let view = SelectSignInMethodViewController()
        view.vm = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    func bind() {
        guard let vm else { return }
        
        let input = SelectSignInMethodViewModel.Input(
            appleSignInButtonTapped: appleSignInButton.rx.tap,
            kakaoSignInButtonTapped: kakaoSignInButton.rx.tap
        )
        let output = vm.transform(input: input)
    }
 
    override func configureView() {
        signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        emailSignInButton.addTarget(self, action: #selector(emailSignInButtonClicked), for: .touchUpInside)
        
        [appleSignInButton,
         kakaoSignInButton,
         emailSignInButton,
         signUpButton
        ].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        appleSignInButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view).inset(35)
            make.top.equalTo(view).inset(42)
            make.height.equalTo(44)
        }
        
        kakaoSignInButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(appleSignInButton)
            make.top.equalTo(appleSignInButton.snp.bottom).offset(16)
            make.height.equalTo(44)
        }
        
        emailSignInButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(appleSignInButton)
            make.top.equalTo(kakaoSignInButton.snp.bottom).offset(16)
            make.height.equalTo(44)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(appleSignInButton)
            make.top.equalTo(emailSignInButton.snp.bottom).offset(16)
            make.height.equalTo(20)
        }
    }
    
}

extension SelectSignInMethodViewController {
    
    @objc func signUpButtonClicked() {
        let vc = UINavigationController(rootViewController: SignUpViewController())
        present(vc, animated: true)
    }
    
    @objc func emailSignInButtonClicked() {
        let vc = UINavigationController(rootViewController: EmailSignInViewController())
        present(vc, animated: true)
    }
    
}

extension SelectSignInMethodViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}
