//
//  ContentView.swift
//  NeuroSketch
//
//  Created by 최희진 on 8/23/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                // 메인 콘텐츠 영역
            }
            .padding()
            .toolbar {
                ToolbarItem(placement:  .navigationBarTrailing) {
                    NavigationLink(destination: DrawingView()) {
                        Image(systemName: "pencil")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
