//
//  ChattingViewModel.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/20.
//

import Foundation

import RxCocoa
import RxSwift

protocol ChattingViewModelDelegate {
    func backButtonTapped()
}

final class ChattingViewModel: ViewModelType {

    let viewDidLoad = BehaviorRelay<Void>(value: ())
    
    var channel = BehaviorRelay<Channel?>(value: nil)
    var delegate: ChattingViewModelDelegate?
    
    let loginUserID = LoginUser.shared.load()?.userID
    
    private let chattingRepository: ChattingRepository
    private let disposeBag = DisposeBag()
    
    init(chattingRepository: ChattingRepository) {
        self.chattingRepository = chattingRepository
    }
    
    struct Input {
        let chat: ControlProperty<String>
        let sendButtonTapped: ControlEvent<Void>
        let backButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let chats: BehaviorRelay<[ChannelChat]>
        let textViewText: PublishRelay<String>
        let scrollToBottom: PublishRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        let chats = BehaviorRelay<[ChannelChat]>(value: [])
        let textViewText = PublishRelay<String>()
        let scrollToBottom = PublishRelay<Bool>()
        
        viewDidLoad
            .subscribe(with: self) { owner, _ in
                guard let channel = owner.channel.value else { return }
                
                owner.chattingRepository.fetchChat(of: channel.channelID) { response in
                    chats.accept(response)
                    scrollToBottom.accept(true)
                    
                    owner.chattingRepository.openSocket(id: channel.channelID) { chat in
                        let newChats = chats.value + [chat]
                        
                        chats.accept(newChats)
                        scrollToBottom.accept(true)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input.sendButtonTapped
            .withLatestFrom(input.chat) {
                ChannelChatRequestDTO(content: $1, files: nil)
            }
            .subscribe(with: self) { owner, chatRequest in
                guard let channel = owner.channel.value else { return }
                
                owner.chattingRepository.createChat(of: channel.channelID, chat: chatRequest) { chat in
                    let newChats = chats.value + [chat]
                    
                    chats.accept(newChats)
                    textViewText.accept("")
                    scrollToBottom.accept(true)
                }
                
            }
            .disposed(by: disposeBag)
        
        input.backButtonTapped
            .subscribe(with: self) { owner, _ in
                owner.delegate?.backButtonTapped()
            }
            .disposed(by: disposeBag)
        
        return Output(
            chats: chats,
            textViewText: textViewText,
            scrollToBottom: scrollToBottom
        )
    }
    
}

extension ChattingViewModel {
    
    func closeSocket() {
        chattingRepository.closeSocket()
    }
    
    @objc func socketReopen() {
        viewDidLoad.accept(())
    }
    
}
