//
//  what_s_the_weatherApp.swift
//  what's the weather
//
//  Created by hermann kao on 12/09/2022.
//

import SwiftUI

@main
struct what_s_the_weatherApp: App {
    @StateObject private var store = CityStore()
    @State private var errorWrapper: ErrorWrapper?

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView{
                    CityStore.save(cities: store.cities) { result in
                        Task {
                           do {
                               try await CityStore.save(cities: store.cities)
                           } catch {
                               errorWrapper = ErrorWrapper(error: error, guidance: "Réessayez plus tard.")
                           }
                       }

                    }
                }
                .colorScheme(.dark)
                .environmentObject(store)
                .onDisappear {
                    store.stopGeolocationHandler()
                }
            }.task {
                do {
                    store.cities = try await CityStore.load()
                    store.startGeolocationHandler()
                    store.updateAllCities()
                } catch {
                    errorWrapper = ErrorWrapper(error: error, guidance: "L'application va continuer son execution sans aucune donnée.")
                }
            }.sheet(
                item: $errorWrapper,
                onDismiss: { store.cities = [] }
            ) { wrapper in ErrorView(errorWrapper: wrapper) }
        }
    }
}
