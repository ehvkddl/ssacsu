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
    
    let chatBox = {
        let view = UIView()
        view.backgroundColor = .Background.primary
        view.layer.cornerRadius = 8
        return view
    }()
    
    let plusButton = {
        let btn = UIButton()
        btn.setImage(.plus, for: .normal)
        return btn
    }()
    
    let sendButton = {
        let btn = UIButton()
        btn.setImage(.ic, for: .normal)
        return btn
    }()
    
    let textView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
//        tv.backgroundColor = .View.alpha
        tv.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tv.isScrollEnabled = false
        
        tv.showsVerticalScrollIndicator = false
        tv.font = SSFont.style(.body)
        return tv
    }()
    
    let maxHeight: CGFloat = 46.6
    
    static func create(
        with viewModel: ChattingViewModel
    ) -> ChattingViewController {
        let view = ChattingViewController()
        view.vm = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .Background.secondary
        
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
        
        textView.rx.didChange
            .bind(with: self) { owner, _ in
                let size = CGSize(width: owner.textView.frame.width, height: .infinity)
                let estimatedSize = owner.textView.sizeThatFits(size)
                
                let isMaxHeight = estimatedSize.height >= owner.maxHeight
                
                guard isMaxHeight != owner.textView.isScrollEnabled else { return }
                
                owner.textView.isScrollEnabled = isMaxHeight
                owner.textView.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
        
        textView.rx.text.orEmpty
            .bind(with: self) { owner, str in
                let image: UIImage = str.count > 0 ? .icActive : .ic
                
                owner.sendButton.setImage(image, for: .normal)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        [plusButton, textView, sendButton].forEach { chatBox.addSubview($0) }
        
        [navigationBar,
         chatBox
        ].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        
        chatBox.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view).inset(16)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-12)
            make.height.greaterThanOrEqualTo(38)
        }
        
        plusButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(chatBox).inset(9)
            make.leading.equalTo(chatBox).inset(12)
            make.bottom.equalTo(chatBox).inset(9)
            make.width.equalTo(22)
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(chatBox).inset(7)
            make.trailing.equalTo(chatBox).inset(12)
            make.bottom.equalTo(chatBox).inset(7)
            make.width.equalTo(24)
        }
        
        textView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(chatBox).inset(10)
            make.leading.equalTo(plusButton.snp.trailing).offset(8)
            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
            make.centerY.equalTo(chatBox)
            make.height.lessThanOrEqualTo(maxHeight)
        }
    }
    
}
