//
//  PressureView.swift
//  what's the weather
//
//  Created by hermann kao on 06/10/2022.
//

import SwiftUI

struct PressureView: View {
    @Binding var city: City
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "gauge")
                Text("Pression (hPa)").font(.headline)
                Spacer()
            }
            .foregroundColor(.white.opacity(0.7))
                .padding(.top, 6)
                .padding(.bottom, 3)
                .padding(.leading)
            Divider().overlay(.white.opacity(0.5))
            Gauge(value: Float(city.pressure), in: 0...2000) { }
            currentValueLabel: {
                VStack (spacing: 0){
                    Text("\(Int(city.pressure))")
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            minimumValueLabel: {
                Image(systemName: "arrow.down").foregroundColor(.white.opacity(0.7))
            } maximumValueLabel: {
                Image(systemName: "arrow.up").foregroundColor(.white.opacity(0.7))
            }
                .tint(.white)
                .gaugeStyle(.accessoryCircular)
                .scaleEffect(2)
                .frame(width: 100, height: 100)
                .padding()
        }
            .background(
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(.white.opacity(0.1))
        )
            .padding()
    }
}

struct PressureView_Previews: PreviewProvider {
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
            VStack(alignment: .leading, spacing: 2) {
                PressureView(
                    city: .constant(City())
                )
            }
                .padding()
        )
    }
}
