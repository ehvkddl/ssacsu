//
//  workspaceEmptyView.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/23.
//

import UIKit

class WorkspaceEmptyView: UIView {
    
    private let explain1 = "워크스페이스를 찾을 수 없어요."
    private let explain2 = """
관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나
새로운 워크스페이스를 생성해주세요
"""
    
    private lazy var explainLabel1 = SSLabel(text: explain1,
                                             font: SSFont.style(.title1))
    
    private lazy var explainLabel2 = SSLabel(text: explain2,
                                             font: SSFont.style(.body))
    
    private let emptyImageView = {
        let img = UIImageView(image: .workspaceEmpty)
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let createWorkspaceButton = SSButton(title: "워크스페이스 생성", style: .plain)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        [explainLabel1,
         explainLabel2,
         emptyImageView,
         createWorkspaceButton
        ].forEach { addSubview($0) }
    }
    
    func setConstraints() {
        explainLabel1.snp.makeConstraints { make in
            make.top.equalTo(self).inset(35)
            make.horizontalEdges.equalTo(self).inset(24)
        }
        
        explainLabel2.snp.makeConstraints { make in
            make.top.equalTo(explainLabel1.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(explainLabel1)
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(12)
            make.center.equalTo(self)
        }
        
        createWorkspaceButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(24)
            make.bottom.equalTo(self).inset(24)
            make.height.equalTo(44)
        }
    }
    
}
