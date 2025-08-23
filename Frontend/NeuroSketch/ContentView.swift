//
//  ContentView.swift
//  NeuroSketch
//
//  Created by 최희진 on 8/23/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isDrawing: Bool = false
    
    var body: some View {
        VStack {
            Button(action: {
                isDrawing = true
            }, label: {
                Text("그림 그리기")
            })
        }
        .padding()
        .fullScreenCover(isPresented: $isDrawing) {
            DrawingView()
        }
    }
}

#Preview {
    ContentView()
}
