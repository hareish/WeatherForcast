//
//  TemparatureGaugeView.swift
//  what's the weather
//
//  Created by hermann kao on 30/09/2022.
//

import SwiftUI

struct TemperatureGaugeView: View {
    let gradient = Gradient(colors: [.green, .yellow, .orange, .red])
    var min: Double
    var max: Double
    var current: Double
    var body: some View {
        Gauge(value: current, in: min...max) { }
        currentValueLabel: {
            Text("\(Int(current))°").foregroundColor(.white.opacity(0.7))
        }
        minimumValueLabel: {
            Text("\(Int(min))°").foregroundColor(.white.opacity(0.7))
        } maximumValueLabel: {
            Text("\(Int(max))°").foregroundColor(.white.opacity(0.7))
        }
            .tint(gradient)
            .gaugeStyle(.accessoryLinear)
            .padding()
    }
}

struct TemperatureGaugeView_Previews: PreviewProvider {
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
                TemperatureGaugeView(min: 9.0, max: 22.6, current: 12.6)
            }.background(
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundColor(.white.opacity(0.1))
            )
                .padding()
        )
    }
}
