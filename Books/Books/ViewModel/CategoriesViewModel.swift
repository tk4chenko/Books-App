//
//  CategoriesViewModel.swift
//  Books
//
//  Created by Artem Tkachenko on 06.07.2023.
//

import Foundation

protocol CategoriesViewModelProtocol {
    var networkService: BooksNetworkServiceProtocol { get }
    var categories: Observable<[CategoriesResponse]?> { get }
    var error: Observable<String?> { get }
    func getCategories(useCache: Bool) async
}

final class CategoriesViewModel: CategoriesViewModelProtocol {

    let networkService: BooksNetworkServiceProtocol
    
    let categories: Observable<[CategoriesResponse]?> = Observable(nil)
    let error: Observable<String?> = Observable(nil)
    
    init(networkService: BooksNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getCategories(useCache: Bool) async {
        do {
            self.categories.value = try await networkService.getCategories(useCache: useCache).results
        } catch {
            self.error.value = error.localizedDescription
        }
    }
    
}
