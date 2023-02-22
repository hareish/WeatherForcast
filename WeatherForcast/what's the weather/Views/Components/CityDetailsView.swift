//
//  CityDetailsView.swift
//  what's the weather
//
//  Created by hermann kao on 06/10/2022.
//

import SwiftUI

struct CityDetailsView: View {
    @Binding var city: City
    var body: some View {
        VStack{
            HStack{
                PressureView(city: $city)
                WindSpeedView(city: $city)
            }
        }
    }
}

struct CityDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        LinearGradient(
            gradient: Gradient(
                colors: [Color.blue.opacity(0.5), Color.blue]
            ),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
            .ignoresSafeArea()
            .overlay(
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        CityDetailsView(city: .constant(City()))
                    }
                }
            }
        )
    }
}
