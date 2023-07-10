//
//  Endpoints.swift
//  Books
//
//  Created by Artem Tkachenko on 10.07.2023.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }
    var host: String {
        return "api.nytimes.com"
    }
}
