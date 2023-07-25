//
//  MainCoordinator.swift
//  Books
//
//  Created by Artem Tkachenko on 25.07.2023.
//

import UIKit

class MainCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    
    let navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        openCategoriesViewController()
    }
    
    func openCategoriesViewController() {
        let viewModel = CategoriesViewModel(networkService: BooksNetworkService())
        let viewContoller = CategoriesViewController(viewModel: viewModel)
        viewContoller.openBooksViewController = { [weak self] category in
            self?.openBooksViewController(by: category)
        }
        self.navigationController.pushViewController(viewContoller, animated: true)
    }
    
    func openBooksViewController(by category: CategoriesResponse) {
        let viewModel = BooksViewModel(networkService: BooksNetworkService())
        viewModel.list = category
        let viewContoller = BooksViewController(viewModel: viewModel)
        viewContoller.openWebViewController = { [weak self] url in
            self?.openWebViewController(with: url)
        }
        viewContoller.openDescriptionViewController = { [weak self] overview in
            self?.descriptionViewController(with: overview)
        }
        self.navigationController.pushViewController(viewContoller, animated: true)
    }
    
    func openWebViewController(with url: URL) {
        let viewController = WebViewController(url: url)
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func descriptionViewController(with overview: String) {
        let viewController = DescriptionViewController(overview: overview)
        if let sheet = viewController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
                sheet.detents = [.medium()]
        }
        navigationController.present(viewController, animated: true, completion: nil)
    }
}
