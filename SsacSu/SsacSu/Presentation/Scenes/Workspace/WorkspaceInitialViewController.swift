//
//  WorkspaceInitialViewController.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/13.
//

import UIKit

class WorkspaceInitialViewController: BaseViewController {
    
    private let completeLabel1 = SSLabel(text: "출시 준비 완료!",
                                 font: SSFont.style(.title1))
    
    private let str = """
옹골찬 고래밥님의 조직을 위해 새로운 싹수 워크스페이스를
시작할 준비가 완료되었어요!
"""
    private lazy var completeLabel2 = SSLabel(text: str,
                                 font: SSFont.style(.body))
    
    let LaunchingImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(resource: .launching)
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    let createWorkspaceButton = SSButton(title: "워크스페이스 생성", style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        title = "시작하기"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .close, style: .plain, target: self, action: #selector(clickedCloseButton))
    }
    
    override func configureView() {
        [completeLabel1,
        completeLabel2,
        LaunchingImageView,
        createWorkspaceButton
        ].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        completeLabel1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.horizontalEdges.equalTo(createWorkspaceButton)
        }
        
        completeLabel2.snp.makeConstraints { make in
            make.top.equalTo(completeLabel1.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(createWorkspaceButton)
        }
        
        LaunchingImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view).inset(12)
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        createWorkspaceButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
    }
    
}

extension WorkspaceInitialViewController {
    
    @objc func clickedCloseButton() {
        dismiss(animated: true)
    }
    
}
