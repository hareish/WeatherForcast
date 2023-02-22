//
//  CityManagementView.swift
//  what's the weather
//
//  Created by hermann kao on 05/10/2022.
//

import SwiftUI

struct CityManagementView: View {
    @Binding var selectedCityIndex: Int
    @Environment(\.isSearching) private var isSearching: Bool
    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: CityStore
    @ObservedObject var citySearchVM = CitySearchViewModel()
    let saveAction: () -> Void

    var body: some View {
        CityListView(
            selectedCityIndex: $selectedCityIndex,
            saveAction: saveAction
        )
        .sheet(isPresented: $citySearchVM.isNewCityModalPresented) {
            NavigationView {
                CityView(city: $citySearchVM.selectedCity).toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Annuler") {
                            withAnimation {
                                citySearchVM.isNewCityModalPresented = false
                            }
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Ajouter") {
                            withAnimation {
                                store.cities.append(citySearchVM.selectedCity)
                                saveAction()
                                dismissSearch()
                                citySearchVM.isNewCityModalPresented = false
                            }
                        }.disabled(store.cities.firstIndex(where: { c
                            in c.name.caseInsensitiveCompare(citySearchVM.selectedCity.name) == .orderedSame
                        }) != nil)
                    }
                }
            }
        }
            .searchable(
            text: $citySearchVM.searchString,
            placement: .sidebar,
            prompt: "Rechercher une ville",
            suggestions: {
                ForEach(citySearchVM.searchResults, id: \.matchingFullName) { city in
                    Button(action: {
                        Task {
                            citySearchVM.isNewCityModalPresented = true
                            let result = await citySearchVM.getLatLon(selected: city)
                            citySearchVM.selectedCity = await store.createCityWithLatLon(lat: result.latitude, lon: result.longitude)
                        }
                    }) {
                        Text(city.matchingFullName)
                            .font(.headline)
                    }
                }
            }
        )
    }
}

struct CityManagementView_Previews: PreviewProvider {
    static var previews: some View {
        CityManagementView(
            selectedCityIndex: .constant(-1),
            saveAction: { }
        ).environmentObject(CityStore())
    }
}
