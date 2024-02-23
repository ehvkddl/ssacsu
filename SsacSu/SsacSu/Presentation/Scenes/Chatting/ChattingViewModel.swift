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
    
    var channel = BehaviorRelay<Channel?>(value: nil)
    var delegate: ChattingViewModelDelegate?
    
    let loginUserID = LoginUser.shared.load()?.userID
    
    private let chattingRepository: ChattingRepository
    private let disposeBag = DisposeBag()
    
    init(chattingRepository: ChattingRepository) {
        self.chattingRepository = chattingRepository
    }
    
    struct Input {
        let backButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let chats: BehaviorRelay<[ChannelChat]>
    }
    
    func transform(input: Input) -> Output {
        let chats = BehaviorRelay<[ChannelChat]>(value: [])
        Observable.just(())
            .subscribe(with: self) { owner, _ in
                guard let channel = owner.channel.value else { return }
                
                owner.chattingRepository.fetchChat(of: channel.channelID) { response in
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
        )
    }
    
}
