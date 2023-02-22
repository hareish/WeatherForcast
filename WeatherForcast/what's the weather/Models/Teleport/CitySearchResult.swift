//
//  CitySearchResult.swift
//  what's the weather
//
//  Created by hermann kao on 01/10/2022.
//

import Foundation

// MARK: - CitySearchResult
struct CitySearchResult: Codable {
    let embedded: EmbeddedCitySearchResult
    let links: CitySearchResultLinksClass
    let count: Int

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case links = "_links"
        case count
    }
}

// MARK: - Embedded
struct EmbeddedCitySearchResult: Codable {
    let citySearchResults: [CitySearchResultElement]

    enum CodingKeys: String, CodingKey {
        case citySearchResults = "city:search-results"
    }
}

// MARK: - CitySearchResultElement
struct CitySearchResultElement: Codable, Identifiable {
    let links: CitySearchResultLinks
    let matchingAlternateNames: [MatchingAlternateName]
    let matchingFullName: String

    enum CodingKeys: String, CodingKey {
        case links = "_links"
        case matchingAlternateNames = "matching_alternate_names"
        case matchingFullName = "matching_full_name"
    }
}

extension CitySearchResultElement {
    var id: UUID {
        return UUID()
    }
}

// MARK: - CitySearchResultLinks
struct CitySearchResultLinks: Codable {
    let cityItem: CitySearchResultSelf

    enum CodingKeys: String, CodingKey {
        case cityItem = "city:item"
    }
}

// MARK: - SelfClass
struct CitySearchResultSelf: Codable {
    let href: String
}

// MARK: - MatchingAlternateName
struct MatchingAlternateName: Codable {
    let name: String
}

// MARK: - CitySearchResultLinksClass
struct CitySearchResultLinksClass: Codable {
    let curies: [Cury]
    let linksSelf: CitySearchResultSelf

    enum CodingKeys: String, CodingKey {
        case curies = "curies"
        case linksSelf = "self"
    }
}

// MARK: - Cury
struct Cury: Codable {
    let href, name: String
    let templated: Bool
}

