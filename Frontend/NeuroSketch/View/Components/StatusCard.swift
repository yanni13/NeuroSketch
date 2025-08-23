//
//  StatusCard.swift
//  NeuroSketch
//
//  Created by 아우신얀 on 8/24/25.
//

import SwiftUI

struct StatusCard: View {
    let title: String
    let content: AnyView
    let maxWidth: CGFloat?
    
    init(title: String, maxWidth: CGFloat? = nil, @ViewBuilder content: () -> some View) {
        self.title = title
        self.maxWidth = maxWidth
        self.content = AnyView(content())
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
            content
        }
        .padding(14)
        .frame(maxWidth: maxWidth, minHeight: 88, maxHeight: 88)
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

struct EmotionCard: View {
    let emoji: String
    let emotion: String
    
    var body: some View {
        StatusCard(title: "현재 감정", maxWidth: 98) {
            HStack {
                Text(emoji)
                Text(emotion)
            }
        }
    }
}

struct StatusIndicatorCard: View {
    let statusText: String
    let backgroundColor: Color
    let indicatorColor: Color
    
    var body: some View {
        StatusCard(title: "상태") {
            HStack(spacing: 10) {
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundStyle(indicatorColor)
                
                Text(statusText)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
            .frame(maxWidth: .infinity, minHeight: 23, alignment: .center)
            .background(backgroundColor)
            .cornerRadius(20)
        }
    }
}
