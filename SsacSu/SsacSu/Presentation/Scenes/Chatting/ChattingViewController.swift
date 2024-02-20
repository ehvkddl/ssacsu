//
//  ChattingViewController.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/19.
//

import UIKit

final class ChattingViewController: BaseViewController {
    
    var vm: ChattingViewModel!
    
    let navigationBar = {
        let navBar = CommonNavigationBar(title: "title",
                                      leftItemImage: .back,
                                      rightItemImage: .list)
        return navBar
    }()
    
    static func create(
        with viewModel: ChattingViewModel
    ) -> ChattingViewController {
        let view = ChattingViewController()
        view.vm = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    func bind() {
        let input = ChattingViewModel.Input(
            backButtonTapped: navigationBar.leftItem.rx.tap
        )
        let output = vm.transform(input: input)
        
        vm.channel
            .compactMap { $0 }
            .map { "#\($0.name)" }
            .asDriver(onErrorJustReturn: "채널명")
            .drive(navigationBar.title.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        [navigationBar].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
}
