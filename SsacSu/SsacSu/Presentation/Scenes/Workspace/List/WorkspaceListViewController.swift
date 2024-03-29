//
//  WorkspaceListViewController.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/31.
//

import UIKit

import RxCocoa
import RxSwift

class WorkspaceListViewController: BaseViewController {
    
    var vm: WorkspaceListViewModel!
    
    let backgroundView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    let backgroundTapGesture = UITapGestureRecognizer()
    
    let sideMenuView = {
        let view = UIView()
        view.backgroundColor = .Background.secondary
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        return view
    }()
    
    let navBackgroundView = {
        let view = UIView()
        view.backgroundColor = .Background.primary
        return view
    }()
    
    let viewLabel = SSLabel(text: "워크스페이스",
                            font: SSFont.style(.title1),
                            textAlignment: .left)
    
    let tableView = {
        let tv = UITableView()
        
        tv.register(WorkspaceListTableViewCell.self, forCellReuseIdentifier: WorkspaceListTableViewCell.description())
        
        tv.separatorStyle = .none
        
        return tv
    }()
    
    let addWorkspaceButton = SSButton(image: .plus,
                                      title: "워크스페이스 추가",
                                      style: .custom)
    
    let helpButton = SSButton(image: .help,
                              title: "도움말",
                              style: .custom)
    
    static func create(
        with viewModel: WorkspaceListViewModel
    ) -> WorkspaceListViewController {
        let view = WorkspaceListViewController()
        view.vm = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        bind()
    }
    
    func bind() {
        let input = WorkspaceListViewModel.Input(
            backgroundTapGesture: backgroundTapGesture.rx.event,
            itemSelected: tableView.rx.itemSelected,
            modelSelected: tableView.rx.modelSelected(Workspace.self)
        )
        let output = vm.transform(input: input)
        
        output.workspaceList
            .bind(to: tableView.rx.items) { tableView, row, element in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkspaceListTableViewCell.description()) as? WorkspaceListTableViewCell else { return UITableViewCell() }

                cell.selectionStyle = .none
                
                cell.nameLabel.text = element.name
                cell.createdAtLabel.text = DateFormatter.dateWithDots.string(from: element.createdAt)
                
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        view.addSubview(backgroundView)
        view.addSubview(sideMenuView)
        backgroundView.addGestureRecognizer(backgroundTapGesture)
        
        [navBackgroundView, viewLabel,
         tableView,
         addWorkspaceButton,
         helpButton
        ].forEach { sideMenuView.addSubview($0) }
    }
    
    override func setConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sideMenuView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.trailing.equalTo(view).multipliedBy(0.83)
        }
        
        navBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(sideMenuView)
            make.horizontalEdges.equalTo(sideMenuView)
            make.bottom.equalTo(tableView.snp.top)
        }
        
        viewLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(sideMenuView).inset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(viewLabel.snp.bottom).offset(17)
            make.horizontalEdges.equalTo(sideMenuView)
            make.bottom.equalTo(addWorkspaceButton.snp.top)
        }
        
        addWorkspaceButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(sideMenuView)
            make.bottom.equalTo(helpButton.snp.top)
        }
        
        helpButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(sideMenuView)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
    }
    
}
