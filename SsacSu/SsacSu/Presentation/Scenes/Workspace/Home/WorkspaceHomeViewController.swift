//
//  WorkspaceHomeViewController.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/22.
//

import UIKit

class WorkspaceHomeViewController: BaseViewController {
    
    var vm: WorkspaceHomeViewModel!
    
    let workspaceImage = {
        let img = UIImageView()
        img.backgroundColor = .blue
        img.layer.cornerRadius = 8
        return img
    }()
    
    let workspaceName = {
        let lbl = UILabel()
        lbl.text = "No Workspace"
        lbl.font = SSFont.style(.title1)
        return lbl
    }()
    
    let profileImage = {
        let img = UIImageView()
        img.backgroundColor = .green
        img.layer.cornerRadius = img.frame.width * 0.5
        return img
    }()
    
    let divider = Divider()
    
    let emptyView = WorkspaceEmptyView()
    
    static func create(
        with viewModel: WorkspaceHomeViewModel
    ) -> WorkspaceHomeViewController {
        let view = WorkspaceHomeViewController()
        view.vm = viewModel
        return view
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImage.layer.cornerRadius = profileImage.frame.width * 0.5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    func bind() {
        let input = WorkspaceHomeViewModel.Input(
            createWorkspaceButtonTapped: emptyView.createWorkspaceButton.rx.tap
        )
        let output = vm.transform(input: input)
    }
    
    override func configureView() {
        [workspaceImage, workspaceName, profileImage,
         divider
        ].forEach { view.addSubview($0) }
        
        view.addSubview(emptyView)
    }
    
    override func setConstraints() {
        workspaceImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view).inset(16)
            make.size.equalTo(32)
        }
        
        workspaceName.snp.makeConstraints { make in
            make.leading.equalTo(workspaceImage.snp.trailing).offset(8)
            make.centerY.equalTo(workspaceImage)
        }
        
        profileImage.snp.makeConstraints { make in
            make.trailing.equalTo(view).inset(16)
            make.centerY.equalTo(workspaceImage)
            make.size.equalTo(32)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(workspaceImage.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view)
            make.height.equalTo(1)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}
