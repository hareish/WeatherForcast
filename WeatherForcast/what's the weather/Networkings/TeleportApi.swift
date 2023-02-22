//
//  TeleportApi.swift
//  what's the weather
//
//  Created by hermann kao on 01/10/2022.
//

import Foundation
import Alamofire

class TeleportApi {
    var baseUrl = "https://api.teleport.org/api"

    func searchCityByName(name: String, completion: @escaping (CitySearchResult) -> Void) {
        AF
            .request("\(baseUrl)/cities/?search=\(name)")
            .responseDecodable(of: CitySearchResult.self) { response in
            guard let citySearchResult = response.value else {
                print("searchCityByName Erreur: \(response.error?.localizedDescription ?? "Erreur inconnue")")
                return
            }
            completion(citySearchResult)
        }
    }

    func searchCityByName(name: String) async -> CitySearchResult {
        await withCheckedContinuation { continuation in
            searchCityByName(name: name) { result in
                continuation.resume(returning: result)
            }
        }
    }

    func getNearestFromLatLong(lat: Double, long: Double, completion: @escaping (NearestCitySearchResult) -> Void) {
        AF.request("\(baseUrl)/locations/\(lat),\(long)/").responseDecodable(of: NearestCitySearchResult.self) {
            response in
            guard let result = response.value else {
                print("getNearestFromLatLong Erreur: \(response.error?.localizedDescription ?? "Erreur inconnue")")
                return
            }
            completion(result)
        }
    }

    func getNearestFromLatLong(lat: Double, long: Double) async -> NearestCitySearchResult {
        await withCheckedContinuation { continuation in
            getNearestFromLatLong(lat: lat, long: long) { result in
                continuation.resume(returning: result)
            }
        }
    }

    func getCityByUrl(url: String, completion: @escaping (CityByGeonameIdResult) -> Void) {
        AF.request(url).responseDecodable(of: CityByGeonameIdResult.self) {
            response in
            guard let result = response.value else {
                print("getCityByUrl Erreur: \(response.error?.localizedDescription ?? "Erreur inconnue")")
                return
            }
            completion(result)
        }
    }

    func getCityByUrl(url: String) async -> CityByGeonameIdResult {
        await withCheckedContinuation { continuation in
            getCityByUrl(url: url) { result in
                continuation.resume(returning: result)
            }
        }
    }

    func getUrbanAreaImageByUrl(urbanAreaUrl: String, completion: @escaping (UrbanAreaImageResult) -> Void) {
        AF.request("\(urbanAreaUrl)images").responseDecodable(of: UrbanAreaImageResult.self) {
            response in
            guard let result = response.value else {
                print("getUrbanAreaImageByUrl Erreur: \(response.error?.localizedDescription ?? "Erreur inconnue")")
                return
            }
            completion(result)
        }
    }

    func getUrbanAreaImageByUrl(urbanAreaUrl: String) async -> UrbanAreaImageResult {
        await withCheckedContinuation { continuation in
            getUrbanAreaImageByUrl(urbanAreaUrl: urbanAreaUrl) { result in
                continuation.resume(returning: result)
            }
        }
    }

    func getUrbanAreaImagesFromSlug(slug: String, completion: @escaping (UrbanAreaImageResult) -> Void) {
        AF.request("\(baseUrl)/urban_areas/slug:\(slug)/images/").responseDecodable(of: UrbanAreaImageResult.self) {
            response in
            guard let result = response.value else {
                print("getUrbanAreaImagesFromSlug Erreur: \(response.error?.localizedDescription ?? "Erreur inconnue")")
                return
            }
            completion(result)
        }
    }

    func getUrbanAreaImagesFromSlug(slug: String) async -> UrbanAreaImageResult {
        await withCheckedContinuation { continuation in
            getUrbanAreaImagesFromSlug(slug: slug) { result in
                continuation.resume(returning: result)
            }
        }
    }

    func extractGeonameId(url: String) -> Int {
        if(!url.contains("geonameid:")) {
            print("URL does not contain geonameid")
        }
        let components = url.components(separatedBy: "/")
        let withGeo = components[components.count - 2]
        let subComponents = withGeo.components(separatedBy: ":")
        if let res = Int(subComponents[subComponents.count - 1]) {
            return res
        } else {
            return Int.random(in: 70..<500)
        }
    }
}

