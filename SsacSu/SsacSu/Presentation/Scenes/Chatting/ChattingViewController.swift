//
//  ChattingViewController.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/19.
//

import UIKit

import RxCocoa
import RxSwift

final class ChattingViewController: BaseViewController {
    
    var vm: ChattingViewModel!
    
    let navigationBar = {
        let navBar = CommonNavigationBar(title: "title",
                                         leftItemImage: .back,
                                         rightItemImage: .list)
        return navBar
    }()
    
    let chatTableView = {
        let tv = UITableView()
        
        tv.register(OtherChattingBubbleTableViewCell.self, forCellReuseIdentifier: OtherChattingBubbleTableViewCell.description())
        tv.register(MyChattingBubbleTableViewCell.self, forCellReuseIdentifier: MyChattingBubbleTableViewCell.description())
        
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 100
        
        tv.separatorStyle = .none
        
        return tv
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
        tv.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tv.isScrollEnabled = false
        
        tv.showsVerticalScrollIndicator = false
        tv.font = SSFont.style(.body)
        return tv
    }()
    
    let maxHeight: CGFloat = 46.6
    
    var profileImageUrl: [Int: String] = [:] {
        didSet {
            print(profileImageUrl)
        }
    }
    var profileImages: [Int: UIImage?] = [:] {
        didSet {
            print(profileImages)
        }
    }
    
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
        
        addSocketReopenObserver()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        vm.closeSocket()
        removeSocketReopenObserver()
    }
    
    func bind() {
        let input = ChattingViewModel.Input(
            chat: textView.rx.text.orEmpty,
            sendButtonTapped: sendButton.rx.tap,
            backButtonTapped: navigationBar.leftItem.rx.tap
        )
        let output = vm.transform(input: input)
        
        vm.channel
            .compactMap { $0 }
            .map { "#\($0.name)" }
            .asDriver(onErrorJustReturn: "채널명")
            .drive(navigationBar.title.rx.text)
            .disposed(by: disposeBag)
        
        output.chats.bind(to: chatTableView.rx.items) { [unowned self] (tableView, row, element) -> UITableViewCell in
            let chatUser = element.user
            
            let loginUserID = vm.loginUserID
            let chatUserID = chatUser.userID
            
            switch chatUserID {
            case loginUserID:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChattingBubbleTableViewCell.description()) as? MyChattingBubbleTableViewCell else { return UITableViewCell() }
                
                cell.selectionStyle = .none
                
                cell.chatBubbleLabel.text = element.content
                
                return cell
                
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherChattingBubbleTableViewCell.description()) as? OtherChattingBubbleTableViewCell else { return UITableViewCell() }
                
                profileImageObserve(chatUser)
                
                cell.selectionStyle = .none
                
                cell.profileImage.image = profileImages[chatUserID] ?? .Profile.noPhotoA
                cell.nicknameLabel.text = element.user.nickname
                cell.chatBubbleLabel.text = element.content
                
                return cell
            }
        }
        .disposed(by: disposeBag)
        
        output.scrollToBottom
            .bind(with: self) { owner, _ in
                let chats = output.chats.value
                
                guard chats.count > 0 else { return }
                
                owner.chatTableView.scrollToRow(at: IndexPath(row: chats.count - 1, section: 0), at: .none, animated: false)
            }
            .disposed(by: disposeBag)
        
        output.textViewText
            .bind(to: textView.rx.text)
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
         chatTableView,
         chatBox
        ].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        
        chatTableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(chatBox.snp.top).offset(-8)
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

extension ChattingViewController {
    
    func addSocketReopenObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(socketReopen),
                                               name: NSNotification.Name("SocketReopen"),
                                               object: nil)
    }
    
    func removeSocketReopenObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name("SocketReopen"),
                                                  object: nil)
    }
    
    @objc func socketReopen() {
        vm.socketReopen()
    }
    
}

extension ChattingViewController {
    
    private func profileImageObserve(_ user: User) {
        guard let url = user.profileImage else { return }
        
        if let imageUrl = profileImageUrl[user.userID] {
            // nil이 아닌 경우
            let isSame = imageUrl == url
            if isSame == false {
                updateProfileImage(key: user.userID, value: imageUrl)
            }
        } else {
            updateProfileImage(key: user.userID, value: url)
        }
    }
    
    private func updateProfileImage(key userID: Int, value imageUrl: String) {
        profileImageUrl[userID] = imageUrl
        
        ImageHelper.download(url: imageUrl, size: CGSize(width: 40, height: 40)) { [unowned self] image in
            print("다운 성공했으니까 이미지 바꺼주께용")
            profileImages[userID] = image
        }
    }
    
}
