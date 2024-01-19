//
//  OnboardingViewController.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/07.
//

import UIKit

protocol OnboardingViewControllerDelegate {
    func startSsacsu()
}

class OnboardingViewController: BaseViewController {

    var delegate: OnboardingViewControllerDelegate?
    
    private let str = """
싹수를 사용하면 어디서나
팀을 모을 수 있습니다
"""
    private lazy var explainLabel = SSLabel(text: str, 
                                            font: SSFont.style(.title1))
    
    private let onboardingImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(resource: .onboarding)
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private let startButton = SSButton(title: "시작하기", style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setConstraints()
    }
    
    override func configureView() {
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        
        [explainLabel,
         onboardingImageView,
         startButton
        ].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(view).inset(90)
            make.horizontalEdges.equalTo(view).inset(24)
        }
        
        onboardingImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view).inset(12)
            make.center.equalTo(view)
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
    }

}

extension OnboardingViewController {
    
    @objc func startButtonClicked() {
        self.delegate?.startSsacsu()
    }
    
}
