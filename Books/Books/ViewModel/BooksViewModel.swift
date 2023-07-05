//
//  BooksViewModel.swift
//  Books
//
//  Created by Artem Tkachenko on 06.07.2023.
//

import Foundation

protocol BooksViewModelProtocol {
    var list: CategoriesResponse? { get }
    var networkService: NetworkService { get }
    var books: Observable<[Book]?> { get }
    func getBooks()
}

final class BooksViewModel: BooksViewModelProtocol {
    
    var list: CategoriesResponse? = nil
    
    let networkService = NetworkService()
    
    let books: Observable<[Book]?> = Observable(nil)
    
    func getBooks() {
        let url = "https://api.nytimes.com/svc/books/v3/lists/\(list?.newestPublishedDate ?? "")/\(list?.listNameEncoded ?? "").json?api-key=\(Constants.apikey)"
        networkService.get(with: url) { (result: Result<Welcome, Error>) in
            switch result {
            case .success(let success):
                self.books.value = success.results?.books
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
}

enum Constants: String {
    case apikey = "qEbukI8vVZs34j4JSyiiUZatE116iTP8"
}
