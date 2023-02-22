//
//  CityListView.swift
//  what's the weather
//
//  Created by hermann kao on 02/10/2022.
//

import SwiftUI

struct CityListView: View {
    @Binding var selectedCityIndex: Int
    @EnvironmentObject private var store: CityStore
    @Environment(\.presentationMode) private var presentationMode
    let saveAction: () -> Void
    @State private var isEditing = false

    var body: some View {
        NavigationView {
            List {
                CityCardView(city: $store.currentCity, isCurrentCity: .constant(true))
                    .onTapGesture {
                    onPress(index: -1)
                }.listRowInsets(EdgeInsets())
                ForEach($store.cities) { $city in
                    CityCardView(city: $city, isCurrentCity: .constant(false))
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                        withAnimation {
                            onPress(index: store.cities.firstIndex(of: city) ?? 0)
                        }
                    }.swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            withAnimation {
                                store.removeCity(city: city)
                                saveAction()
                            }
                        } label: {
                            Image(systemName: "trash").foregroundColor(.red)
                        }
                    }.tint(.clear)
                }
                .onDelete(perform: removeItem)
                .onMove(perform: moveItem)
            }
                .listStyle(PlainListStyle())
                .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive))
                .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    if(store.isUpdatingCities) {
                        ProgressView()
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Méteo").font(.headline)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Menu {
                        Button(action: { self.isEditing.toggle() }) {
                            withAnimation {
                                Text(isEditing ? "Terminer" : "Modifier la liste")
                            }
                        }
                        Button(action: { store.imperial = true }) {
                            if(store.imperial) {
                                Image(systemName: "checkmark")
                            }
                            Text("Farenheit \t°F")
                        }
                        Button(action: { store.imperial = false }) {
                            HStack(alignment: .center) {
                                if(!store.imperial) {
                                    Image(systemName: "checkmark")
                                }
                                Text("Celsius \t°C")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle").foregroundColor(.white)
                    }
                }
            }
        }
            .navigationBarBackButtonHidden(true)

    }


    func onPress(index: Int) {
        selectedCityIndex = index
        self.presentationMode.wrappedValue.dismiss()
    }

    func removeItem(at offsets: IndexSet) {
        store.cities.remove(atOffsets: offsets)
        saveAction()
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        store.cities.move(fromOffsets: source, toOffset: destination)
        saveAction()
    }
}

struct CityListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CityListView(
                selectedCityIndex: .constant(-1),
                saveAction: { }
            ).environmentObject(CityStore())
        }
    }
}
