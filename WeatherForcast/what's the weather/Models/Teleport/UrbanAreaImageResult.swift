//
//  UrbanAreaImageResult.swift
//  what's the weather
//
//  Created by hermann kao on 01/10/2022.
//

import Foundation

// MARK: - UrbanAreaResult
struct UrbanAreaImageResult: Codable {
    let links: UrbanAreaImageLinks
    let photos: [UrbanAreaImagePhoto]

    enum CodingKeys: String, CodingKey {
        case links = "_links"
        case photos
    }
}

// MARK: - Links
struct UrbanAreaImageLinks: Codable {
    let curies: [UrbanAreaImageCury]
}

// MARK: - Cury
struct UrbanAreaImageCury: Codable {
    let href: String
    let name: String
}

// MARK: - Photo
struct UrbanAreaImagePhoto: Codable {
    let attribution: UrbanAreaImageAttribution
    let image: UrbanAreaImageImage
}

// MARK: - Attribution
struct UrbanAreaImageAttribution: Codable {
    let license, photographer, site: String
    let source: String
}

// MARK: - Image
struct UrbanAreaImageImage: Codable {
    let mobile, web: String
}
