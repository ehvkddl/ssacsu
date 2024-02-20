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
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let backButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        input.backButtonTapped
            .subscribe(with: self) { owner, _ in
                owner.delegate?.backButtonTapped()
            }
            .disposed(by: disposeBag)
        
        
        return Output()
    }
    
}
