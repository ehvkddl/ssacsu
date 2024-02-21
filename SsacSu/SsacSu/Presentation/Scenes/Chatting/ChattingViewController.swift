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

    let chatDummy: [ChannelChat] = [
        ChannelChat(channelId: 348, channelName: "일반", chatId: 5265, content: "안녕하세요", createdAt: Date(), files: [], user: User(userID: 100, email: "chap@sesac.com", nickname: "찹쌀", profileImage: nil)),
        ChannelChat(channelId: 348, channelName: "일반", chatId: 5265, content: "반갑습니다~", createdAt: Date(timeIntervalSinceNow: 1), files: [], user: User(userID: 200, email: "chap@sesac.com", nickname: "찹쌀", profileImage: nil)),
        ChannelChat(channelId: 348, channelName: "일반", chatId: 5265, content: "저희 수료식이 언제였죠? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?", createdAt: Date(timeIntervalSinceNow: 1), files: [], user: User(userID: 200, email: "chap@sesac.com", nickname: "찹쌀", profileImage: nil)),
        ChannelChat(channelId: 348, channelName: "일반", chatId: 5265, content: "방가방가", createdAt: Date(timeIntervalSinceNow: 1), files: [], user: User(userID: 100, email: "chap@sesac.com", nickname: "찹쌀", profileImage: nil)),
        ChannelChat(channelId: 348, channelName: "일반", chatId: 5265, content: "잘부탁드려요", createdAt: Date(timeIntervalSinceNow: 2), files: [], user: User(userID: 100, email: "chap@sesac.com", nickname: "찹쌀", profileImage: nil)),
        ChannelChat(channelId: 348, channelName: "일반", chatId: 5265, content: "문래역 근처 맛집 추천 받습니다~ 창작촌이 있어서 생각보다 맛집 많을거 같은데 막상 어디를 가야할지 잘 모르겠.. 맛잘알 계신가요?", createdAt: Date(timeIntervalSinceNow: 2), files: [], user: User(userID: 100, email: "chap@sesac.com", nickname: "찹쌀", profileImage: nil))
    ]
    
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
        
        let chats: Observable<[ChannelChat]> = Observable.of(chatDummy)
        chats.bind(to: chatTableView.rx.items) { [unowned self] (tableView, indexPath, element) -> UITableViewCell in
            let loginUserID = vm.loginUserID
            let chatUserID = element.user.userID
            
            switch chatUserID {
            case loginUserID:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChattingBubbleTableViewCell.description()) as? MyChattingBubbleTableViewCell else { return UITableViewCell() }
                
                cell.selectionStyle = .none
                
                cell.chatBubbleLabel.text = element.content
                
                return cell
                
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherChattingBubbleTableViewCell.description()) as? OtherChattingBubbleTableViewCell else { return UITableViewCell() }
                
                cell.selectionStyle = .none
                
                cell.nicknameLabel.text = element.user.nickname
                cell.chatBubbleLabel.text = element.content
                
                return cell
            }
        }
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
