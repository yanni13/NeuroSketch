//
//  LottieView.swift
//  NeuroSketch
//
//  Created by 아우신얀 on 8/23/25.
//

import SwiftUI
import Lottie

struct LottieComponent: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            if appState.isLoggedIn{
                LottieView(animation: .named("Sprout plant"))
                    .playing()
                    .looping()
                    .frame(width: 300, height: 300)
                    .scaleEffect(1.5)
                    .offset(y: -100)
            }
            
            Image("plant")
                .frame(width: 166, height: 144)
            
        }
    }
}
