//
//  ViewModel.swift
//  Books
//
//  Created by Artem Tkachenko on 06.07.2023.
//

import Foundation

protocol ViewModelProtocol {
    var networkService: NetworkService { get }
    var categories: Observable<[CategoriesResponse]?> { get }
    func getCategories()
}

final class ViewModel: ViewModelProtocol {
    
    let networkService = NetworkService()
    
    let categories: Observable<[CategoriesResponse]?> = Observable(nil)
    
    func getCategories() {
        networkService.get(with: "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=\(Constants.apikey)") { (result: Result<CategoriesWelcome, Error>) in
            switch result {
            case .success(let success):
                self.categories.value = success.results
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
}
