//
//  BookModel.swift
//  Books
//
//  Created by Artem Tkachenko on 06.07.2023.
//

import Foundation

struct BooksWelcome: Codable {
    let status, copyright: String?
    let numResults: Int?
    let lastModified: String?
    let results: Results?
    let fault: Fault?
}

struct Results: Codable {
    let listName, bestsellersDate, publishedDate, displayName: String?
    let normalListEndsAt: Int?
    let updated: String?
    let books: [Book]?
}

struct Book: Codable {
    let rank, rankLastWeek, weeksOnList, asterisk: Int?
    let dagger: Int?
    let primaryIsbn10: String?
    let primaryIsbn13, publisher, description: String?
    let price: String?
    let title, author, contributor, contributorNote: String?
    let bookImage: String?
    let amazonProductUrl: String?
    let ageGroup, bookReviewLink, firstChapterLink, sundayReviewLink: String?
    let articleChapterLink: String?
}
