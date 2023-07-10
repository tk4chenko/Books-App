//
//  BooksNetworkService.swift
//  Books
//
//  Created by Artem Tkachenko on 10.07.2023.
//

import Foundation

protocol BooksNetworkServiceProtocol {
    func getCategories(useCache: Bool) async throws -> CategoriesWelcome
    func getBooks(date: String, list: String) async throws -> BooksWelcome
}

struct BooksNetworkService: HTTPClient, BooksNetworkServiceProtocol {

    private let decoder: JSONDecoder = {
        $0.keyDecodingStrategy = .convertFromSnakeCase
        return $0
    }(JSONDecoder())
    
    func getCategories(useCache: Bool) async throws -> CategoriesWelcome {
        do {
            return try await sendRequest(
                endpoint: BooksEndpoint.categories,
                useCache: useCache,
                decoder: decoder
            )
        } catch {
            throw error
        }
    }
    
    func getBooks(date: String, list: String) async throws -> BooksWelcome {
        do {
            return try await sendRequest(
                endpoint: BooksEndpoint.books(date: date, list: list),
                useCache: true,
                decoder: decoder
            )
        } catch {
            throw error
        }
    }
}
