//
//  BooksEndpoint.swift
//  Books
//
//  Created by Artem Tkachenko on 10.07.2023.
//

import Foundation

enum BooksEndpoint {
    case categories
    case books(date: String, list: String)
}

extension BooksEndpoint: Endpoint {
    var path: String {
        switch self {
        case .categories:
            return "/svc/books/v3/lists/names.json"
        case .books(date: let date, list: let list):
            return "/svc/books/v3/lists/\(date)/\(list).json"
        }
    }
    var method: RequestMethod {
        switch self {
        case .categories, .books:
            return .get
        }
    }
    var header: [String: String]? {
        return nil
    }
    var body: [String: String]? {
        return nil
    }
    var queryItems: [URLQueryItem]? {
        switch self {
        case .categories, .books:
            return [
                URLQueryItem(name: "api-key", value: Constants.API.apiKey)
            ]
        }
    }
}
