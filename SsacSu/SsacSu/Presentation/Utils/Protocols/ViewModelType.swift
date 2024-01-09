//
//  ViewModelType.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/10.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
