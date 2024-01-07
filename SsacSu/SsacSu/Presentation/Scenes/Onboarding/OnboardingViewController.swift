//
//  OnboardingViewController.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/07.
//

import UIKit
import SnapKit

class OnboardingViewController: UIViewController {

    let explainLabel = {
        let lbl = UILabel()
        lbl.setTextWithFont(text: "싹수를 사용하면 어디서나\n팀을 모을 수 있습니다", fontStyle: .title1)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let onboardingImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(resource: .onboarding)
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    let startButton = SSButton(title: "시작하기", style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .Background.primary
        
        configureView()
        setConstraints()
    }
    
    func configureView() {
        [explainLabel,
         onboardingImageView,
         startButton
        ].forEach { view.addSubview($0) }
    }
    
    func setConstraints() {
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
