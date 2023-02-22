//
//  ContentView.swift
//  what's the weather
//
//  Created by hermann kao on 12/09/2022.
//

import SwiftUI

struct ContentView: View {
    let saveAction: () -> Void
    @State var selectedIndex: Int = -1
    @EnvironmentObject var store: CityStore

    var body: some View {
        LinearGradient(
            gradient: Gradient(
                colors: [Color.blue.opacity(0.5), Color.blue]
            ),
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
            .ignoresSafeArea()
            .overlay(
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedIndex) {
                    CityView(isCurrent: .constant(true), city: $store.currentCity).tabItem {
                        Image(systemName: "location")
                    }.tag(-1).padding(.bottom, 50)
                    ForEach($store.cities.indices, id: \.self) { index in
                        CityView(city: $store.cities[index]).tabItem {
                            Text("\(index)")
                        }
                            .tag(index)
                            .padding(.bottom, 50)
                    }
                }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                HStack {
                    NavigationLink(destination: MapView()) {
                        Image(systemName: "map")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    NavigationLink(
                        destination: CityManagementView(
                            selectedCityIndex: $selectedIndex,
                            saveAction: saveAction
                        )
                            .environmentObject(store)
                    ) {
                        Image(systemName: "list.bullet")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                    .padding()
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView(
                saveAction: { }
            ).environmentObject(CityStore())
        }
    }
}
