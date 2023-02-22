//
//  NearestCitySearchResult.swift
//  what's the weather
//
//  Created by hermann kao on 01/10/2022.
//

import Foundation

// MARK: - NearestCitySearchResult
struct NearestCitySearchResult: Codable {
    let embedded: NearestCitySearchResultEmbedded
    let links: NearestCitySearchResultLinks
    let coordinates: Coordinates

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case links = "_links"
        case coordinates
    }
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latlon: Latlon
}

// MARK: - Latlon
struct Latlon: Codable {
    let latitude, longitude: Double
}

// MARK: - Embedded
struct NearestCitySearchResultEmbedded: Codable {
    let locationNearestCities: [LocationNearestCity]
    let locationNearestUrbanAreas: [LocationNearestUrbanArea]

    enum CodingKeys: String, CodingKey {
        case locationNearestCities = "location:nearest-cities"
        case locationNearestUrbanAreas = "location:nearest-urban-areas"
    }
}

// MARK: - LocationNearestCity
struct LocationNearestCity: Codable {
    let links: LocationNearestCityLinks

    enum CodingKeys: String, CodingKey {
        case links = "_links"
    }
}

// MARK: - LocationNearestCityLinks
struct LocationNearestCityLinks: Codable {
    let locationNearestCity: CitySearchResultSelf

    enum CodingKeys: String, CodingKey {
        case locationNearestCity = "location:nearest-city"
    }
}

// MARK: - LocationNearestUrbanArea
struct LocationNearestUrbanArea: Codable {
    let links: LocationNearestUrbanAreaLinks

    enum CodingKeys: String, CodingKey {
        case links = "_links"
    }
}

// MARK: - LocationNearestUrbanAreaLinks
struct LocationNearestUrbanAreaLinks: Codable {
    let locationNearestUrbanArea: CitySearchResultSelf

    enum CodingKeys: String, CodingKey {
        case locationNearestUrbanArea = "location:nearest-urban-area"
    }
}

// MARK: - NearestCitySearchResultLinks
struct NearestCitySearchResultLinks: Codable {
    let linksSelf: CitySearchResultSelf

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

