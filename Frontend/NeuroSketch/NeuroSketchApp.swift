//
//  NeuroSketchApp.swift
//  NeuroSketch
//
//  Created by 최희진 on 8/23/25.
//

import SwiftUI

@main
struct NeuroSketchApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
