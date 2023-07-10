//
//  BooksViewModel.swift
//  Books
//
//  Created by Artem Tkachenko on 06.07.2023.
//

import Foundation

protocol BooksViewModelProtocol {
    var list: CategoriesResponse? { get }
    var networkService: BooksNetworkServiceProtocol { get }
    var books: Observable<[Book]?> { get }
    var error: Observable<String?> { get }
    func getBooks() async
}

final class BooksViewModel: BooksViewModelProtocol {
    
    var list: CategoriesResponse? = nil
    
    let networkService: BooksNetworkServiceProtocol
    
    let books: Observable<[Book]?> = Observable(nil)
    let error: Observable<String?> = Observable(nil)
    
    init(networkService: BooksNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getBooks() async {
        do {
            guard let list else { return }
            self.books.value = try await networkService.getBooks(date: list.newestPublishedDate ?? "", list: list.listNameEncoded ?? "").results?.books
        } catch {
            self.error.value = error.localizedDescription
        }
    }
}
