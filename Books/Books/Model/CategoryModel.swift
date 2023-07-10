//
//  CategoryModel.swift
//  Books
//
//  Created by Artem Tkachenko on 06.07.2023.
//

import Foundation

struct CategoriesWelcome: Codable {
    let status, copyright: String?
    let numResults: Int?
    let results: [CategoriesResponse]?
    let fault: Fault?
}

struct Fault: Codable {
    let faultstring: String?
    let detail: Detail?
}

struct Detail: Codable {
    let errorcode: String?
}

struct CategoriesResponse: Codable {
    let listName, displayName, listNameEncoded, oldestPublishedDate: String?
    let newestPublishedDate: String?
    let updated: Updated?
}

enum Updated: String, Codable {
    case monthly = "MONTHLY"
    case weekly = "WEEKLY"
}
