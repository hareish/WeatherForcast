//
//  CitySearchViewModel.swift
//  what's the weather
//
//  Created by hermann kao on 02/10/2022.
//

import Foundation

final class CitySearchViewModel: ObservableObject {
    @Published var selectedCity: City = City()
    @Published var isNewCityModalPresented: Bool = false
    @Published var searchResults: [CitySearchResultElement] = []
    @Published var searchString: String = "" {
        didSet {
            findCities()
        }
    }
    
    let teleportApi = TeleportApi()
    let openWeatherApi = OpenWeatherApi()

    func findCities() {
        teleportApi.searchCityByName(name: searchString) { result in
            self.searchResults = result.embedded.citySearchResults
        }
    }
    
    func getLatLon(selected: CitySearchResultElement, completion: @escaping(Latlon) -> Void){
        teleportApi.getCityByUrl(url: selected.links.cityItem.href){ result in
            completion(result.location.latlon)
        }
    }

    func getLatLon(selected: CitySearchResultElement) async -> Latlon {
        await withCheckedContinuation { continuation in
            getLatLon(selected: selected) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
