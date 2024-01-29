//
//  Coordinator.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/30.
//

import UIKit

protocol Coordinator: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators : [Coordinator] { get set }
    var type: CoordinatorType { get }
    
    func start()
    func finish(next: CoordinatorType?)
}

extension Coordinator {
    func finish(next: CoordinatorType? = nil) {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self, next: next)
    }
}

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator, next: CoordinatorType?)
}

enum CoordinatorType {
    case app, splash
    case sign
    case main
    case workspace
}
