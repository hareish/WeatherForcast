//
//  LottieView.swift
//  what's the weather
//
//  Created by Hareish Jeyakumar on 24/09/2022.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var name: String
    var loopMode: LottieLoopMode = .loop

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> some UIView {
        let view = UIView()
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<LottieView>) {
        uiView.subviews.forEach({ $0.removeFromSuperview() })

        let animationvView = AnimationView()
        animationvView.translatesAutoresizingMaskIntoConstraints = false
        uiView.addSubview(animationvView)

        NSLayoutConstraint.activate([
            animationvView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
            animationvView.heightAnchor.constraint(equalTo: uiView.heightAnchor)
            ])

        animationvView.animation = Animation.named(name)
        animationvView.contentMode = .scaleAspectFit
        animationvView.loopMode = loopMode
        animationvView.play()
    }
}
