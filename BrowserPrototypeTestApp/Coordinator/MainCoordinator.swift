//
//  MainCoordinator.swift
//  BrowserPrototypeTestApp
//
//  Created by Dmitriy Lukyanov on 04.05.2023.
//

import Foundation
import UIKit

enum Event {
    case goToMainVC
    case goToHistoryVC
}

protocol Coordinator {
    var navigationController: UINavigationController? {get set}
    
    func start()
    func eventOccured(with type: Event)
}

protocol Coordinating {
    var coordinator: Coordinator? {get set}
}

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController?
    let container: DIContainer
    
    init(container: DIContainer, navigationController: UINavigationController? = nil) {
        self.container = container
        self.navigationController = navigationController
    }
    
    func start() {
        var vc: UIViewController & Coordinating = MainViewController(container: container)
        vc.coordinator = self
        
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    func eventOccured(with type: Event) {
        switch type {
        case .goToHistoryVC:
            var vc: UIViewController & Coordinating = HistoryViewController(container: container)
            vc.coordinator = self
            navigationController?.pushViewController(vc, animated: true)
        case .goToMainVC:
            navigationController?.popViewController(animated: true)
        }
    }
}
