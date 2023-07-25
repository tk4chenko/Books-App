//
//  AppCoordinator.swift
//  Books
//
//  Created by Artem Tkachenko on 25.07.2023.
//

import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    var window: UIWindow { get }
    func openMainScene()
}

class AppCoordinator: AppCoordinatorProtocol {
    
    weak var parentCoordinator: Coordinator?
    
    let window: UIWindow
    
    var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        openMainScene()
    }
    
    func openMainScene() {
        let coordinator = MainCoordinator(navigationController: UINavigationController())
        window.rootViewController = coordinator.navigationController
        addChildCoordinator(coordinator)
        coordinator.start()
    }
}
